if [ $(uname -s) = "Darwin" ]; then
  #export NVM_DIR="$HOME/.nvm"
  #[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
  [[ -s $(brew --prefix)/etc/profile.d/autojump.sh  ]] && . $(brew --prefix)/etc/profile.d/autojump.sh
  #nvm alias default 11.14.0
  #nvm use v11.14.0
fi

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias cp="rsync -ah --progress"
# alias open="xdg-open"
alias pingtest="ping 8.8.8.8"
alias c='clear'
#alias weka='java -jar ${HOME}/weka-3-8-1/weka.jar'
#alias python='python3'
#alias pip='pip3'
alias bkliton='echo 1 | sudo tee /sys/class/leds/asus::kbd_backlight/brightness'
alias bklitoff='echo 0 | sudo tee /sys/class/leds/asus::kbd_backlight/brightness'
# https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias notes='sudo updatedb; locate -r ${HOME}/".*notes_.*\.md"'
alias def='definition'
alias weather='curl wttr.in'
alias tldr='tldr -t ocean'
alias vim="nvim"
alias sudo='sudo '
alias vbm="VBoxManage"
alias l="exa -lahF"

#if [ $(uname -s) != "Darwin" ]; then
  ##alias rm="trash"
  #alias say="spd-say"
  #alias myip="ifconfig wlp3s0 | grep -m 1 inet | sed 's/^.*inet addr://g' | sed 's/Bcast.*//g'"
  #export MYIP=$(myip)
#fi
[[ -s ${HOME}/.autojump/etc/profile.d/autojump.sh ]] && source ${HOME}/.autojump/etc/profile.d/autojump.sh
