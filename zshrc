 # Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robs"
#ZSH_THEME="agnoster"
ZSH_THEME="cobalt2"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias vi=vim

if [ `uname` = "Darwin" ]; then
  if [ -f "~/.iterm2_shell_integration" ]; then
    source ~/.iterm2_shell_integration.`basename $SHELL`
  fi
  export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python2
	#alias vim=mvim
  export PATH="/usr/local/opt/curl/bin:$PATH"
  if [ -f "/usr/local/bin/archey" ]; then
    if [ -f "$HOME/.archey-ip" ]; then
      /usr/local/bin/archey
    else
      /usr/local/bin/archey -o
    fi
  fi
fi

if [ `uname` = "CYGWIN_NT-6.1" ]; then
  alias cdhosts=/cygdrive/c/Windows/System32/drivers/etc/
  alias desktop=/cygdrive/c/Users/rsletten/Desktop/
  alias downloads=/cygdrive/c/Users/rsletten/Downloads/
  export PATH=$PATH:/cygdrive/c/puppet/bin/
fi

if [[ `uname -r` == *"Microsoft"* ]]; then
  export TERM=xterm-256color
fi

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git osx sublime brew history history-substring-search pip python ruby pyenv virtualenv rbenv gem github jira repo vagrant tmux tmuxinator ssh-agent screen copyfile copydir colorize extract dirpersist)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=~/bin:/usr/local/bin:$PATH:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin

#export http_proxy=http://proxy:8080
#export https_proxy=http://proxy:8080
#export no_proxy=rsletten.com

function validate_yaml() {
  ruby -ryaml -e "YAML.load_file '$1'"
}
function reyaml() {
  ruby -ryaml -e "print YAML.load_file('$1').to_yaml"
}
function validate_erb() {
  erb -P -x -T '-' $1 | ruby -c
}

export EDITOR=vim
nova() { command nova --insecure "$@" 2> /dev/null }
unset LESS
source ~/dotfiles/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# init rbenv
if [ -d "$HOME/.rbenv" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi
# init pyenv
if [ -d "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  alias pip3=pip
  eval "$(pyenv init -)"
fi
# CRC Config
if [ -d "$HOME/.crc" ]; then
  export PATH="$HOME/.crc/bin/oc:$PATH"
  [[ -f crc ]] && eval $(crc oc-env)
fi
umask 022
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_all_dups
alias mux="tmuxinator"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="$HOME/.local/share/gem/ruby/3.0.0/bin:$PATH"
# K8S stuff
alias k=kubectl
alias ka='kubectl apply -f'
alias kd='kubectl delete -f'
alias kg='kubectl get'
alias kx='kubectl exec -i -t'
alias kk='export KUBECONFIG=~/.kube/config.k8s'
alias koc='export KUBECONFIG=~/.kube/config.openshift'
function get_kubernetes_context()
{
  CONTEXT=$(kubectl config current-context 2>/dev/null)
  KUBE_SYMBOL=$'\xE2\x8E\x88 '
  if [ -n "$CONTEXT" ]; then
    NAMESPACE=$(kubectl config view --minify --output 'jsonpath={..namespace}')
    if [ -n "$NAMESPACE" ]; then
      echo "(${KUBE_SYMBOL} ${CONTEXT} :: ${NAMESPACE})"
    else
      echo "(${KUBE_SYMBOL} ${CONTEXT}:None)"
    fi
 fi
}
function refresh-all-pods() {
  echo
  DEPLOYMENT_LIST=$(kubectl -n $1 get deployment -o jsonpath='{.items[*].metadata.name}')
  echo "Refreshing pods in all Deployments"
  for deployment_name in $DEPLOYMENT_LIST ; do
    TERMINATION_GRACE_PERIOD_SECONDS=$(kubectl -n $1 get deployment "$deployment_name" -o jsonpath='{.spec.template.spec.terminationGracePeriodSeconds}')
    if [ "$TERMINATION_GRACE_PERIOD_SECONDS" -eq 30 ]; then
      TERMINATION_GRACE_PERIOD_SECONDS='31'
    else
      TERMINATION_GRACE_PERIOD_SECONDS='30'
    fi
    patch_string="{\"spec\":{\"template\":{\"spec\":{\"terminationGracePeriodSeconds\":$TERMINATION_GRACE_PERIOD_SECONDS}}}}"
    kubectl -n $1 patch deployment $deployment_name -p $patch_string
  done
  echo
}
function ksn() {
  kubectl config set-context --current --namespace=$1
}
