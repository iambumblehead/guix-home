# Honor per-interactive-shell startup file
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi

export GUIX_PROFILE=$HOME/.config/guix/current
. $GUIX_PROFILE/etc/profile
export GUIX_PROFILE=$HOME/.guix-profile
. $GUIX_PROFILE/etc/profile

export XDG_RUNTIME_DIR=/tmp/
