# ---B--------------B---------------------------------------B--------------B--- #
# ---------------------- SSSSSSS AAAAAAA GGGGGGG EEEEEEE ---------------------- #
# ---A--------------A--- S       A     A G       E       ---A--------------A--- #
# ---------------------- SSSSSSS AAAAAAA GGGGGGG EEEEEEE ---------------------- #
# ---S--------------S---       S A     A G     G E       ---S--------------S--- #
# ---------------------- SSSSSSS A     A GGGGGGG EEEEEEE ---------------------- #
# ---H--------------H---------------------------------------H--------------H--- #

# ------ CONTENTS ------ #
# 1. Prompt
# 2. Config
# 3. Layout
# 4. Aliases
# 5. Functions
# 6. Exports
# -----------------------#

# ----------------------------------------------------------------------------- #
# -------------------------------- P R O M P T -------------------------------- #
# ----------------------------------------------------------------------------- #

PROMPT_COMMAND=__prompt_command

__prompt_command() {
  local exit="$?"

  local compass='✧'
  local hourglass='⧖'
  local success='⚐'
  local failed='⚑'

  PS1=""
  PS1+="\[$hourglass\] \t \[$compass\] \w "
  PS1+=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\n⑂ \1 /')
  PS1+=$(git log --oneline -n 1 2> /dev/null | sed -e 's/\(.*\)/✎ \1 /')
  PS1+="\n"
  PS1+=$(if [ $exit -eq 0 ]; then echo $success; else echo "$failed"; fi)
  PS1+=" \! -> "
}

# ----------------------------------------------------------------------------- #
# -------------------------------- C O N F I G -------------------------------- #
# ----------------------------------------------------------------------------- #

# -> EDITING <- #
set -o vi       # Turn vi mode on

# -> OPTIONS <- #
shopt -s autocd # Cd when command is a path

# -> HISTORY <- #
HISTSIZE=       # Save every command in the history list
HISTFILESIZE=   # Never truncate the history list

# ----------------------------------------------------------------------------- #
# -------------------------------- L A Y O U T -------------------------------- #
# ----------------------------------------------------------------------------- #

# -> COMMON <- #
mkdir -p $HOME/{Pictures,Videos,Music,Graphics,Downloads,Documents}

# -> DEVELOPMENT <- #
mkdir -p $HOME/Code/{pkg,bin,src}
mkdir -p $HOME/Code/src/github.com/ericsage

# -> SECRETS <-#
mkdir -p $HOME/.secrets/keys

# -> VIM <-#
mkdir -p $HOME/.vim/{backup,tmp,undo}

# ----------------------------------------------------------------------------- #
# ------------------------------- A L I A S E S ------------------------------- #
# ----------------------------------------------------------------------------- #

# -> MOVEMENT <- #
alias ~='cd ~'
alias ..='cd ../'
alias ...='cd ../../'

alias doc='cd ~/Documents'
alias dow='cd ~/Downloads'
alias pic='cd ~/Pictures'
alias vid='cd ~/Videos'
alias mus='cd ~/Music'
alias gra='cd ~/Graphics'

alias code='cd ~/Code/src'
alias sage='cd ~/Code/src/github.com/ericsage'

alias keys='cd ~/.secrets/keys'

# -> VIM <- #
alias v='vim'
alias vi='vim'

# -> GIT <- #
alias g='git'

# -> HISTORY <- #
alias gh='history | grep'

# -> DOTFILES <- #
alias evi='vim ~/.vimrc'
alias ebash='vim ~/.bash_rc'
alias egit='vim ~/.gitconfig'

# -> TMUX <- #
alias tm='tmux -u2'
alias tmux='tmux -u2'
alias tn='tmux new -s'
alias ta='tmux attach -t'
alias ts='tmux switch -t'
alias twn='tmux new-window'
alias tws='tmux select-window'
alias tv='tmux split-window'
alias th='tmux split-window -h'
alias tl='tmux list-sessions'

# -> DOCKER <- #
alias d='docker'
alias dc='docker-compose'
alias dm='docker-machine'

# -> KUBERNETES <- #
alias ku='kubectl'

# ----------------------------------------------------------------------------- #
# ----------------------------- F U N C T I O N S ----------------------------- #
# ----------------------------------------------------------------------------- #

# ----------------------------------------------- #
# -> dkill: Kill and remove a container <- #
dkill () { eval "$(docker kill $1 && docker rm $1)" ; }
# ----------------------------------------------- #

# ----------------------------------------------- #
# -> mans: Search manpage from first argument for term in second argument <- #
mans () { man $1 | grep -iC2 --color=always $2 | less ; }
# ----------------------------------------------- #

# ----------------------------------------------- #
# -> httpHeaders: Grabs headers from web page <- #
httpHeaders () { /usr/bin/curl -I -L $@ ; }
# ----------------------------------------------- #

# ----------------------------------------------- #
# -> httpDebug: Download a web page and show info on what took time <- #
httpDebug () {
  /usr/bin/curl $@ -o /dev/null -w "
  dns: %{time_namelookup}
  connect: %{time_connect}
  pretransfer: %{time_pretransfer}
  starttransfer: %{time_starttransfer}
  total: %{time_total}\n
  " ;
}
# ----------------------------------------------- #

# ----------------------------------------------------------------------------- #
# ------------------------------- E X P O R T S ------------------------------- #
# ----------------------------------------------------------------------------- #

# -> GENERAL <- #
export LANG=en_US.UTF-8
export PATH=$PATH:$HOME/Code/bin
export SAGE=$HOME/Code/src/github.com/ericsage

# -> GO <- #
export GOPATH=$HOME/Code

# -> LESS <- #
export LESS='R'

# -> FZF <- #
export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

# ----------------------------------------------------------------------------- #

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/lib/google-cloud-sdk/path.bash.inc' ]; then source '/usr/lib/google-cloud-sdk/path.bash.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/usr/lib/google-cloud-sdk/completion.bash.inc' ]; then source '/usr/lib/google-cloud-sdk/completion.bash.inc'; fi
