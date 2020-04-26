#
# ~/.bashrc
#

[[ $- != *i* ]] && return

# Completion
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize
shopt -s expand_aliases
# Enable history appending instead of overwriting.  #139609
shopt -s histappend
# Delete history duplicates
export HISTCONTROL=ignoreboth:erasedups

# Change the window title of X terminals
case ${TERM} in
    xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*|st*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
        ;;
    screen*|tmux*)
        PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
        ;;
esac

# Remove ctrl+s freeze
stty susp undef

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less
alias ls='ls --color=auto'
alias la='ls --color=auto -lah'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'

export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"
export CM_LAUNCHER="rofi"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_USER_CONFIG_DIR="$HOME/.config"

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/.local/lib

# Prompt
export PROMPT_DIRTRIM=3
export PS1="\[\033[01;32m\]\u\[\033[00m\]: \[\033[01;34m\]\w\[\033[00m\]\n$ "

# Default editor and pager
VISUAL=nvim; export VISUAL EDITOR=nvim; export EDITOR
PAGER=less; export PAGER

# My aliases
alias ll="ls -l"
alias la="ls -la"
alias tmux="env TERM=xterm-256color tmux"
alias stack-ghcid="ghcid --command 'stack ghci'"
alias vim="nvim"
alias g="git"
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias hgrep="history | grep --color=auto"
alias headphones="sudo rmmod btusb ; sudo modprobe btusb"
alias open="gio open"
function cdl(){ cd $1; ls -l;}

[ -f ~/.bashrc_personal ] && source ~/.bashrc_personal
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -d ~/.fzf ] && \
  PATH=$PATH:~/.fzf/bin ;\
  source ~/.fzf/shell/completion.bash ;\
  source ~/.fzf/shell/key-bindings.bash

# Setup gpg-agent
unset SSH_AGENT_PID
[ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ] && \
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"

export GPG_TTY=$(tty)

[ pgrep gpg-agent >/dev/null 2>&1 ] && gpg-connect-agent updatestartuptty /bye >/dev/null
[ -f ~/.scripts/f.sh ] && source ~/.scripts/f.sh; alias j="f jobs"
