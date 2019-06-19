export ZSH=""

ZSH_THEME="eastwood"
CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
plugins=(git)

source $ZSH/oh-my-zsh.sh

[ -f "$HOME/.alias" ] && source "$HOME/.alias"

for i in $HOME/.zsh_local/*.sh; do
    source "$i"
done