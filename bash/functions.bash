# explain.sh begins
explain () {
  if [ "$#" -eq 0 ]; then
    while read  -p "Command: " cmd; do
      curl -Gs "https://www.mankier.com/api/explain/?cols="$(tput cols) --data-urlencode "q=$cmd"
    done
    echo "Bye!"
  elif [ "$#" -eq 1 ]; then
    curl -Gs "https://www.mankier.com/api/explain/?cols="$(tput cols) --data-urlencode "q=$1"
  else
    echo "Usage"
    echo "explain                  interactive mode."
    echo "explain 'cmd -o | ...'   one quoted command to explain it."
  fi
}

# mkdir + cd
function mkdircd() {
  command mkdir $1 && cd $1
}

# markdown table generator
function mdtable() {
  if [ $(uname -s) = "Darwin" ]; then
    command open -a "Google Chrome" ~/Tools/Markdown-Table-Generator/index.html
  fi
}

if [[ -z "$TMUX" ]] && [ "$SSH_CONNECTION" != "" ]; then
  tmux attach-session -t main || tmux new-session -s main
fi
