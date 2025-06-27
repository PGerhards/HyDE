#!/usr/bin/env zsh

# My old config start
# # cleaning up home folder
# PATH="$HOME/.local/bin:$PATH"
#
# # XDG User Directories
# XDG_DESKTOP_DIR="${XDG_DESKTOP_DIR:-"$(xdg-user-dir DESKTOP)"}"
# XDG_DOWNLOAD_DIR="${XDG_DOWNLOAD_DIR:-"$(xdg-user-dir DOWNLOAD)"}"
# XDG_TEMPLATES_DIR="${XDG_TEMPLATES_DIR:-"$(xdg-user-dir TEMPLATES)"}"
# XDG_PUBLICSHARE_DIR="${XDG_PUBLICSHARE_DIR:-"$(xdg-user-dir PUBLICSHARE)"}"
# XDG_DOCUMENTS_DIR="${XDG_DOCUMENTS_DIR:-"$(xdg-user-dir DOCUMENTS)"}"
# XDG_MUSIC_DIR="${XDG_MUSIC_DIR:-"$(xdg-user-dir MUSIC)"}"
# XDG_PICTURES_DIR="${XDG_PICTURES_DIR:-"$(xdg-user-dir PICTURES)"}"
# XDG_VIDEOS_DIR="${XDG_VIDEOS_DIR:-"$(xdg-user-dir VIDEOS)"}"

# LESSHISTFILE=${LESSHISTFILE:-/tmp/less-hist}
# PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"
# SCREENRC="$XDG_CONFIG_HOME"/screen/screenrc

# export XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME \
#     XDG_CACHE_HOME XDG_DESKTOP_DIR XDG_DOWNLOAD_DIR \
#     XDG_TEMPLATES_DIR XDG_PUBLICSHARE_DIR XDG_DOCUMENTS_DIR \
#     XDG_MUSIC_DIR XDG_PICTURES_DIR XDG_VIDEOS_DIR \
#     SCREENRC
# my old config end

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
ZDOTDIR="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}"

if ! source $ZDOTDIR/.zshenv; then
    echo "FATAL Error: Could not source $ZDOTDIR/.zshenv"
    return 1
fi
