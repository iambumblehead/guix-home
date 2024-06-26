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

if [ -n "$BASH_VERSION" ]; then
    myfunc() {
        export PS1="${BOLD}${YELLOW}\u${GREEN}@${BLUE}\h ${GREEN}\W$(day)\\$ ${RESET}"
    }
    PROMPT_COMMAND="myfunc"
else
    # works on _both_ `bash` _and_ `ash`
    PS1='`echo -ne "${BOLD}${YELLOW}\u${GREEN}@${BLUE}\h ${GREEN}\W$(day)\\$ ${RESET}"`'
fi
export MUSL_LOCPATH=/usr/share/i18n/locales/musl


# enable foot to open same directory Ctrl+shift+n
osc7_cwd() {
    local strlen=${#PWD}
    local encoded=""
    local pos c o
    for (( pos=0; pos<strlen; pos++ )); do
        c=${PWD:$pos:1}
        case "$c" in
            [-/:_.!\'\(\)~[:alnum:]] ) o="${c}" ;;
            * ) printf -v o '%%%02X' "'${c}" ;;
        esac
        encoded+="${o}"
    done
    printf '\e]7;file://%s%s\e\\' "${HOSTNAME}" "${encoded}"
}
PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }osc7_cwd

# myopener() {
#    bash $XDG_CONFIG_HOME/sh/sh.opener.sh $1
#    # bash /home/bumble/software/guix-home/bash.opener.sh $1
# }
# export OPENER="myopener"
