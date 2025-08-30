# function fish_prompt -d "Write out the prompt"
#     # This shows up as USER@HOST /home/user/ >, with the directory colored
#     # $USER and $hostname are set by fish, so you can just use them
#     # instead of using `whoami` and `hostname`
#     printf '%s@%s %s%s%s > ' $USER $hostname \
#         (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
# end
#
if status is-interactive
    set fish_greeting

end

# starship init fish | source
# if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
#     cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
# end
    

function fish_prompt
     printf '%s' (basename $PWD) (fish_git_prompt) ' $ ' (set_color normal)
end

source ~/.config/fish/alias.fish


zoxide init fish | source
# source ~/.asdf/plugins/dotnet/set-dotnet-env.fish
~/.local/bin/mise activate fish | source

set -x WINEPREFIX "/mnt/nvme0n1p5/projects/wineprefix"
set -gx EDITOR nvim
set -gx POSTING_PAGER fx
set -gx PATH /home/dossancto/.dotnet/tools $PATH
