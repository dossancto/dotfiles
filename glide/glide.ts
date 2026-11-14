glide.keymaps.set("normal", "co", ({ tab_id }) => {
	void browser.tabs.get(tab_id).then(async (tab) => {
		if (tab.windowId === undefined) return;

		const otherTabIds = (await browser.tabs.query({ windowId: tab.windowId }))
			.filter((otherTab) => otherTab.id !== undefined && otherTab.id !== tab_id)
			.map((otherTab) => otherTab.id!);

		if (otherTabIds.length > 0) {
			await browser.tabs.remove(otherTabIds);
		}
	});
});

const newTabMacros: Record<string, string> = {
	yt: "https://www.youtube.com/results?search_query={searchTerm}",
        down: 'https://downdetector.com.br/search/?q={searchTerm}',
        aur: 'https://archlinux.org/packages/?sort=&q={searchTerm}&maintainer=&flagged=',
        flat: 'https://flathub.org/apps/search?q={searchTerm}',
        gh: 'https://github.com/search?o=desc&q={searchTerm}&s=stars',

};
const defaultSearchUrl = "https://duckduckgo.com/?q={searchTerm}";

function expandNewTabInput(input: string): string | undefined {
	const match = input.trim().match(/^!(\S+)(?:\s+([\s\S]*))?$/);
	if (!match) return undefined;

	const name = match[1];
	if (!name) return undefined;

	const searchTerm = match[2] ?? "";
	const template = newTabMacros[name];
	return template?.replaceAll("{searchTerm}", encodeURIComponent(searchTerm));
}

async function openTab(input: string, disposition: "CURRENT_TAB" | "NEW_TAB"): Promise<void> {
	const value = input.trim();
	if (!value) {
		if (disposition === "NEW_TAB") await browser.tabs.create({});
		return;
	}

	const macroUrl = expandNewTabInput(value);
	if (macroUrl) {
		if (disposition === "NEW_TAB") await browser.tabs.create({ url: macroUrl });
		else await browser.tabs.update((await glide.tabs.active()).id, { url: macroUrl });
		return;
	}

	if (/^(?:[a-z][a-z\d+.-]*:|www\.)/i.test(value)) {
		if (disposition === "NEW_TAB") await browser.tabs.create({ url: value });
		else await browser.tabs.update((await glide.tabs.active()).id, { url: value });
		return;
	}

	const searchUrl = defaultSearchUrl.replace("{searchTerm}", encodeURIComponent(value));
	if (disposition === "NEW_TAB") await browser.tabs.create({ url: searchUrl });
	else await browser.tabs.update((await glide.tabs.active()).id, { url: searchUrl });
}

function showOpenCommandline(disposition: "CURRENT_TAB" | "NEW_TAB", input = ""): void {
	const macroOptions = Object.keys(newTabMacros).map((name) => ({
		label: `!${name} <search term>`,
		description: "Search in a new tab",
		matches({ input }: { input: string }) {
			return input.trim().split(/\s+/, 1)[0] === `!${name}`;
		},
		execute({ input }: { input: string }) {
			void openTab(input, disposition);
		},
	}));

	glide.commandline.show({
		input,
		title: disposition === "NEW_TAB" ? "open new tab" : "edit current tab",
		options: [
			...macroOptions,
			{
				label: "URL or search",
				description: "Open a URL or search the web in a new tab",
				matches({ input }) {
					return expandNewTabInput(input) === undefined;
				},
				execute({ input }) {
					void openTab(input, disposition);
				},
			},
		],
	});
}

glide.keymaps.set("normal", "o", async () => {
	showOpenCommandline("CURRENT_TAB", "");
}, { description: "Edit the current tab's URL or search" });

glide.keymaps.set("normal", "O", () => {
	showOpenCommandline("NEW_TAB");
}, { description: "Open a URL or search in a new tab" });
