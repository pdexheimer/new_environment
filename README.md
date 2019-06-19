These are scripts intended for my use in setting up a new environment.

## Setup

Run `sh -c "$(curl -fsSL https://raw.githubusercontent.com/pdexheimer/new_environment/master/install_or_update.sh)"`

The install script will respect the following environment variables if set:

| Variable | Meaning |
|----------|---------|
| ZSH | [Oh My Zsh](https://ohmyz.sh) install directory |
| UTILS_DIR | [Command line utils](https://github.com/pdexheimer/cmdline_utils) install directory |
| NEW_ENV_DIR | Install directory for this repository |

## Operations

The script will:

1. Download or update this repository as appropriate
2. Install [Oh My Zsh](https://ohmyz.sh).  If it's already installed, run the Oh My Zsh upgrade script
3. Download or update the [Command line utils](https://github.com/pdexheimer/cmdline_utils)
4. Install a new .zshrc (existing file is backed up)
5. Install a new .vimrc (existing file is backed up)
6. (On a Mac) Install [Homebrew](https://brew.sh).  If it's already installed, run `brew update`
7. (On a Mac) Using Homebrew, install or update [Python 3](https://formulae.brew.sh/formula/python) and [R](https://formulae.brew.sh/formula/r)