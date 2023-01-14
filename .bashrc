alias grep="grep --color=auto"
alias ll="ls -l"
alias ls="ls -p --color=auto"
# Bash initialization for interactive non-login shells and
# for remote shells (info "(bash) Bash Startup Files").

# Export 'SHELL' to child processes.  Programs such as 'screen'
# honor it and otherwise use /bin/sh.
export SHELL

if [[ $- != *i* ]]
then
    # We are being invoked from a non-interactive shell.  If this
    # is an SSH session (as in "ssh host command"), source
    # /etc/profile so we get PATH and other essential variables.
    [[ -n "$SSH_CLIENT" ]] && source /etc/profile

    # Don't do anything else.
    return
fi

# Source the system-wide file.
if [[ -e /etc/bashrc ]]; then
    source /etc/bashrc
fi

# Adjust the prompt depending on whether we're in 'guix environment'.
if [ -n "$GUIX_ENVIRONMENT" ]
then
    PS1='\u@\h \w [env]\$ '
else
    PS1='\u@\h \w\$ '
fi

RESET="\[$(tput sgr0)\]"
YELLOW="\[$(tput setaf 3)\]"
GREEN="\[$(tput setaf 2)\]"
BLUE="\[$(tput setaf 4)\]"
BOLD="\[$(tput bold)\]"
day() {
    date +%a
}

myfunc() { 
    export PS1="${BOLD}${YELLOW}\u${GREEN}@${BLUE}\h ${GREEN}\W$(day)\\$ ${RESET}"
}
PROMPT_COMMAND="myfunc"
