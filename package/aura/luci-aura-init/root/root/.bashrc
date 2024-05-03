#--Openwrt Bash Config--#
PS1='\[\e[32m\][\[\e[m\]\[\e[31m\]\u\[\e[m\]\[\e[33m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]:\W\[\e[m\]\[\e[32m\]]\[\e[0m\] \$\[\e[m\] '
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias le='less'
alias cls='clear'
alias c='clear'
alias ping6='ping -6'
alias ping4='ping -4'
alias pw='pwd'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias l='ls -CF'
alias s='ls -CF'
alias lt='tree'
alias la='ls -lhta'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ip='ip --color=auto'
alias diff='diff --color=auto'
alias dd='dd status=progress'
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
