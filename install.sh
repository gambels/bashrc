#!/bin/bash
set -ue

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
echo "Installing bashrc from $DIR"

set +u
BASHRC=$(cat << BASHRC_EOF
# =============================================================================
# File: .bashrc
# Description: Main bash run command script
# =============================================================================

if [ -f /etc/profile ]; then
    source /etc/profile
fi

# =============================================================================
# Bash Config
# =============================================================================

# Bash rc path
export BASHRC_PATH="$DIR/bashrc"

# Add a local binary path for scripts
export PATH="\${HOME}/bin:\${PATH}"

# Set alternative prompt user name.
export PROMPT_USER=""

# Misc defaults
export HISTCONTROL="ignoreboth"
export HISTSIZE=10000
export PROMPT_DIRTRIM=0

# Enable ANSI color escape
export LESS=-R

# Default Editor
export EDITOR=vim

# Default Man Pager
export MANPAGER="vim -M +MANPAGER -c 'set noma nolist nonumber showtabline=1 cc=""' -"

# SSH server administration
unset SSH_AGENT_PID
if [ "\${gnupg_SSH_AUTH_SOCK_by:-0}" -ne \$\$ ]; then
SSH_AUTH_SOCK="\$(gpgconf --list-dirs agent-ssh-socket)"
export SSH_AUTH_SOCK
fi

# =============================================================================
# Non-Interactive Shell
# =============================================================================

if [[ \$- != *i* ]] ; then
  # Shell is non-interactive
  return
fi

# =============================================================================
# Terminal Settings
# =============================================================================

if [ "\$TERM" != 'linux' ] && [ "\$TERM" != 'screen' ]; then
  # Set the default 256 color TERM
  export TERM=xterm-256color
fi

# Disable XOFF (interrupt data flow)
stty -ixoff

# Disable XON (interrupt data flow)
stty -ixon

# =============================================================================
# Bash Settings
# =============================================================================

declare -A bashrc_settings

bashrc_settings['addons']=1
bashrc_settings['aliases']=1
bashrc_settings['bindings']=1
bashrc_settings['colors']=1
bashrc_settings['completions']=1
bashrc_settings['options']=1
bashrc_settings['prompt']=1

# Lib settings
bashrc_settings['lib/archives']=1
bashrc_settings['lib/commons']=1
bashrc_settings['lib/datetime']=1
bashrc_settings['lib/features']=1
bashrc_settings['lib/files']=1
bashrc_settings['lib/find']=1
bashrc_settings['lib/openssl']=1
bashrc_settings['lib/testing']=1

# Lib devel settings
bashrc_settings['lib/devel/commons']=1
bashrc_settings['lib/devel/git']=1
bashrc_settings['lib/devel/svn']=1
bashrc_settings['lib/devel/watch']=1

# Load settings
for FILE in "\${!bashrc_settings[@]}"
do
  if [ "\${bashrc_settings[\$FILE]}" -eq 1 ]; then
    source "\${BASHRC_PATH}/\${FILE}.sh"
  fi
done

clear

BASHRC_EOF
)
set -u

if [ $# -eq 0 ]; then
  USERS=$(id -un)
elif [ "$1" == "--all" ]; then
  USERS=$(getent passwd | grep /home | cut -d: -f1 | tr '\n' ' ')
else
  USERS=${@:1}
fi

echo "Selected users: $USERS"
for USER in $USERS; do
  user_home=$(eval echo "~$USER")
  user_bashrc="${user_home}/.bashrc"

  echo "$BASHRC" > "$user_bashrc" && chown "$USER"."$USER" "$user_bashrc" || exit 1
  echo "Installed the bash configuration for user '$USER' successfully! Enjoy :-)"
done

exit 0


### EOF ###

