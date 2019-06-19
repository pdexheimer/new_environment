#!/bin/sh

[[ "$OSTYPE" = darwin* ]] || return 0

brew_app_installed() {
    echo $(brew info --json "$@" | jq '.[] | .installed | length')
}

install_or_update_brew_app() {
    if [[ $(brew_app_installed "$@") = 1 ]]; then
        brew upgrade "$@"
    else
        brew install "$@"
    fi
}

which brew > /dev/null
BREW_INSTALLED=$?
if [ $BREW_INSTALLED = 0 ]; then
    brew update
else
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Ensure that the jq JSON query tool is installed
which jq > /dev/null || brew install jq

install_or_update_brew_app "python@3"
install_or_update_brew_app "r"
