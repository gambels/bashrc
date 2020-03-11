#!/bin/bash

# +-------------------------------------------------
# | Usefull Aliases
# +-------------------------------------------------

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ls='ls $COLOR_OPTIONS --group-directories-first --time-style="+%F %H:%M "'
alias l='ls $COLOR_OPTIONS -lahF'
alias grep='grep $COLOR_OPTIONS'
alias egrep='egrep $COLOR_OPTIONS'
alias fgrep='fgrep $COLOR_OPTIONS'
alias mkdir='mkdir -pv'
alias tree='tree -R'
alias openports='netstat -anp --tcp --udp --inet --inet6 | tail -n +1 | sort'

