#!/bin/sh

ZSH=${ZSH:-~/.oh-my-zsh}
NEW_ENV_DIR=${NEW_ENV_DIR:-~/.new_environment}
UTILS_DIR=${UTILS_DIR:-~/bin/utils}

which git > /dev/null || die "No git installed? Aborting"
which curl > /dev/null || die "Curl is required for installing" 

die() {
    echo "Error: $@" >&2
    exit 1
}

update_if_different() {
    DEST=$1
    SRC=$2
    diff -q "$DEST" "$SRC" > /dev/null
    if [ $? != 0 ]; then
        echo "Updating $(basename "$DEST")"
        BACKUP="$DEST-$(date +%Y-%m-%d_%H-%M-%S)"
        mv "$DEST" "$BACKUP"
        cp "$SRC" "$DEST"
    else
        echo "$(basename "$DEST") is already up to date"
    fi
}

# Get (or update) template files
if [ -e "$NEW_ENV_DIR/.git" ]; then
    pushd -q "$NEW_ENV_DIR"
    git pull || die "Couldn't update new_environment"
    popd -q
elif [ -e "$NEW_ENV_DIR" ]; then
    echo "$NEW_ENV_DIR exists and is not a git working copy.  Using as-is"
else
    git clone --depth=1 https://github.com/pdexheimer/new_environment "$NEW_ENV_DIR" || 
        die "Git clone of new_environment failed"
fi

# Install or update Oh My Zsh - https://ohmyz.sh
CURDIR="$(pwd)" #The oh my zsh upgrade script leaves you in the wrong directory
if [ -d "$ZSH" ]; then
    source "$ZSH/tools/upgrade.sh"
else
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi
cd "$CURDIR"

# Get (or update) command-line utils
if [ -e "$UTILS_DIR/.git" ]; then
    pushd -q "$UTILS_DIR"
    git pull || die "Couldn't update cmdline_utils"
    popd -q
elif [ -e "$UTILS_DIR" ]; then
    echo "$UTILS_DIR exists and is not a git working copy.  Using as-is"
else
    git clone --depth=1 https://github.com/pdexheimer/cmdline_utils "$UTILS_DIR" || 
        die "Git clone of cmdline_utils failed"
fi

mkdir -p $HOME/.zsh_local
echo "source $UTILS_DIR/activate" > $HOME/.zsh_local/utils.sh


# Ensure that the .zshrc file has the right settings
sed "/^export ZSH=/ c\\
export ZSH=\"$ZSH\"
" $NEW_ENV_DIR/zshrc > $NEW_ENV_DIR/zshrc.mod
update_if_different "$HOME/.zshrc" "$NEW_ENV_DIR/zshrc.mod"

update_if_different "$HOME/.vimrc" "$NEW_ENV_DIR/vimrc"

if [[ "$OSTYPE" = darwin* ]]; then
    . "$NEW_ENV_DIR/install_or_update.mac.sh"
fi
