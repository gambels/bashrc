#!/bin/bash

source ./colors.sh

# +-------------------------------------------------
# | Style Commandline Prompt
# +-------------------------------------------------

# If set, the value is executed as a command prior to issuing each primary prompt.
PROMPT_COMMAND='RET=$?;'

# Change the window title of X terminals 
case ${TERM} in
  [aEkx]term*|rxvt*|gnome*|konsole*|interix)
    PS1='\[\033]0;\u@\h:\w\007\]'
    ;;
  screen*)
    PS1='\[\033k\u@\h:\w\033\\\]'
    ;;
  *)
    unset PS1
    ;;
esac

# Set colorful PS1 only on colorful terminals.
if ${use_color} ; then
  RET_OUT='$(printf "\[$txtwht\][ret: %-3s]" $RET)'

  if [[ ${EUID} == 0 ]] ; then
    PSL1=$'\n'"${RET_OUT} [\[${bldblu}\]\w\[${txtrst}\]]"
    PSL2=$'\n'"\[${bldred}\]\u@\h \[${bldblu}\]\$\[${txtrst}\] "
  else
    PSL1=$'\n'"${RET_OUT} [\[${bldblu}\]\w\[${txtrst}\]]"
    PSL2=$'\n'"\[${bldylw}\]\u@\h \[${bldblu}\]\$\[${txtrst}\] "
  fi
  PS1+=${PSL1}${PSL2}
else
  RET_OUT='$(printf "[ret: %-3s]" $RET)'

  PSL1=$'\n'"${RET_OUT} [\w]"
  PSL2=$'\n'"\u@\h \$ "

  PS1+=${PSL1}${PSL2}
fi

# This will run before any command is executed.
# We want to run only for the first command, not for the whole
# command line (i.e. at the first command).
function pre_command() {
  if [ -z "$FIRST_COMMAND" ]; then
    return
  fi
  unset FIRST_COMMAND

  # Do stuff.
  echo "Running pre_command"
}
#trap 'pre_command' DEBUG

# This will run after the execution of the previous full command line.
# We don't want to run when first starting a bash session (i.e., at
# the first prompt).
FIRST_PROMPT=1
function post_command() {
  FIRST_COMMAND=1

  if [ -n "$FIRST_PROMPT" ]; then
    unset FIRST_PROMPT
    return
  fi

  # Do stuff.
  echo "Running post_command"
}
#PROMPT_COMMAND+='post_command;'

