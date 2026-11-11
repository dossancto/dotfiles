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

function view_buffer_in_fx
    set tempfile (mktemp)
    
    commandline -b > $tempfile
    
    fx $tempfile
    
    rm -f $tempfile
    
    commandline -f repaint
end

function fish_user_key_bindings
    bind \ef view_buffer_in_fx
end

source ~/.config/fish/alias.fish


zoxide init fish | source

# ASDF configuration code
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Do not use fish_add_path (added in Fish 3.2) because it
# potentially changes the order of items in PATH
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims

~/.local/bin/mise activate fish | source

set -x WINEPREFIX "/mnt/nvme0n1p5/projects/wineprefix"
set -gx EDITOR nvim
set -gx POSTING_PAGER fx
set -gx PATH /home/dossancto/.dotnet/tools $PATH

set -gx DOTNET_ROOT $HOME/.dotnet
set -gx DOTNET_HOST_PATH $HOME/.dotnet/dotnet
fish_add_path $HOME/.dotnet $HOME/.dotnet/tools

# Generated for envman. Do not edit.
test -s ~/.config/envman/load.fish; and source ~/.config/envman/load.fish

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin /home/dossancto/.ghcup/bin $PATH # ghcup-env
