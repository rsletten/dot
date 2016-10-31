# Return immediately if we are not interactive
[ -z "$PS1" ] && return
TERM=xterm-256color
export PATH=$PATH:bin:mark/bin
alias vi=vim
#exec /usr/bin/zsh
function validate_yaml() {
  ruby -ryaml -e "YAML.load_file '$1'"
}
# get current git branch name
function git_branch {
    export gitbranch=[$(git rev-parse --abbrev-ref HEAD 2>/dev/null)]
    if [ "$?" -ne 0 ]
      then gitbranch=
    fi
    if [[ "${gitbranch}" == "[]" ]]
      then gitbranch=
    fi
}
 
# set usercolor based on whether we are running with Admin privs
function user_color {
    id | grep "Admin" > /dev/null
    RETVAL=$?
    if [[ $RETVAL == 0 ]]; then
        usercolor="[0;35m";
    else
        usercolor="[0;32m";
    fi
}

function cygwinify() {
    git config core.autocrlf false
    git rm --cached -r . 
    git reset --hard
}
 
# set TTYNAME
function ttyname() { export TTYNAME=$@; }
 
# Set prompt and window title
inputcolor='[0;37m'
cwdcolor='[0;34m'
gitcolor='[1;31m'
user_color
 
# Setup for window title
export TTYNAME=$$
function settitle() {
  p=$(pwd);
  let l=${#p}-25
  if [ "$l" -gt "0" ]; then
    p=..${p:${l}}
  fi
  t="$TTYNAME $p"
  echo -ne "\e]2;$t\a\e]1;$t\a";
}
 
PROMPT_COMMAND='settitle; git_branch; history -a;'
#export PS1='\[\e${usercolor}\][\u]\[\e${gitcolor}\]${gitbranch}\[\e${cwdcolor}\][$PWD]\[\e${inputcolor}\] $ '
# Bash history settings
export HISTFILESIZE=1000000
export HISTSIZE=100000
export HISTCONTROL=ignorespace
export HISTIGNORE='ls:history:ll'
export HISTTIMEFORMAT='%F %T '
# Append to bash_history instead of overwriting
shopt -s histappend
source ~/git-prompt.sh
export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]$(__git_ps1 " (%s)")\[\033[0m\]\n\$ '
#export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\] ${gitbranch}\n\$ '
#export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
#export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
#source ~/.bash-git-prompt/gitprompt.sh
#GIT_PROMPT_ONLY_IN_REPO=1
eval `dircolors ~/.dir_colors/dircolors.ansi-dark`
alias ll="ls -la --color"
alias ls="ls --color"
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWCOLORHINTS=1
function proxy() {
  if [ $1 == "on" ]; then
    export https_proxy=http://proxy.wellsfargo.com:8080
    export http_proxy=$https_proxy
    export HTTPS_PROXY=http://proxy.wellsfargo.com:8080
    export HTTP_PROXY=$http_proxy
    export no_proxy="192.168.99.100,localhost,127.0.0.0/8"
  else
    unset https_proxy
    unset http_proxy
    unset HTTPS_PROXY
    unset HTTP_PROXY
    unset no_proxy
  fi
}
