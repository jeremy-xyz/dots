# Name: zsh settings
# Author: koltea

setopt HIST_IGNORE_ALL_DUPS
setopt auto_cd
setopt completealiases

# Enable colors and change prompt
autoload -U colors && colors

# newline on prompt & git branch indicator
function precmd {
    if [[ "$NEW_LINE" = true ]] then
		print ""
    else
        NEW_LINE=true
    fi
	vcs_info
}
autoload -Uz vcs_info
alias clear='NEW_LINE=false && clear' # no preceeding newline after clear
zstyle ':vcs_info:git:*' formats 'on %F{011} %b%f'

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
PROMPT='%B%F{cyan}${vcs_info_msg_0_} %F{blue}%1~%F{blue}  '

HISTFILE=~/.config/.history
HISTSIZE=10000
SAVEHIST=1000

# exlcude garbage in history
function hist() {
    [[ "$#1" -lt 7 \
        || "$1" = "run-help "* \
        || "$1" = "cd "* \
        || "$1" = "man "* \
        || "$1" = "h "* \
        || "$1" = "~ "* ]]
    return $(( 1 - $? ))
}

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*' # case-insensitive matching
setopt completealiases
autoload -Uz compinit
compinit

# Include hidden files in autocomplete:
_comp_options+=(globdots)

plugins=(zsh-completions zsh-autosuggestions)
REPORTTIME=15

# Load aliases
[ -f "$ZDOTDIR/zalias" ] && source "$ZDOTDIR/zalias"

# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
