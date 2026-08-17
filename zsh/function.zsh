# Shell functions.
#
# The ssh host-completion zstyles that used to live here moved to completion.zsh,
# where the rest of the completion configuration is.

# explain.sh begins
explain() {
  if [[ $# -eq 0 ]]; then
    # zsh's `read` has no bash-style -p flag (there, -p reads from a coprocess),
    # so the old `read -p "Command: " cmd` never prompted. `read "var?prompt"` is
    # the zsh spelling.
    local cmd
    while read "cmd?Command: "; do
      curl -Gs "https://www.mankier.com/api/explain/?cols=$(tput cols)" --data-urlencode "q=$cmd"
    done
    echo "Bye!"
  elif [[ $# -eq 1 ]]; then
    curl -Gs "https://www.mankier.com/api/explain/?cols=$(tput cols)" --data-urlencode "q=$1"
  else
    echo "Usage"
    echo "explain                  interactive mode."
    echo "explain 'cmd -o | ...'   one quoted command to explain it."
  fi
}

# mkdir + cd
mkdircd() {
  command mkdir -p "$1" && cd "$1"
}

# Echo the kubectl invocation before running it.
# The old body called `command k "$@"`, but `command` skips functions and aliases
# and there is no external `k` binary, so every call died with
# "k: command not found: k". Call kubectl directly instead.
# Defined after alias.zsh has sourced ~/.kubectl_aliases, so drop its `k` alias first.
unalias k 2>/dev/null
k() {
  print -r -- "+ kubectl $*" >&2
  command kubectl "$@"
}

# markdown table generator
mdtable() {
  if [[ $OSTYPE == darwin* ]]; then
    command open -a "Google Chrome" ~/Tools/Markdown-Table-Generator/index.html
  fi
}

# curl cheat.sh
cheat() {
  command curl "cheat.sh/$1"
}

# swagger-edit
swagger-edit() {
  docker run -it --rm --volume="$(pwd)":/swagger -p 8080:8080 zixia/swagger-edit "$@"
}

# Swagger ui preview
# https://github.com/xavierchow/vim-swagger-preview
swagger_yaml2json() {
  local TMP_DIR="/tmp/vim-swagger-preview/"
  local LOG="${TMP_DIR}validate.log"
  docker run --rm -v "$(pwd)":/docs rovecom/swagger-tools swagger-tools validate /docs/"$1" > "$LOG" 2>&1
  if [[ -s "$LOG" ]]; then
    # File exists and has a size greater than zero
    return 1
  else
    docker run -v "$(pwd)":/docs -v "$TMP_DIR":/out swaggerapi/swagger-codegen-cli generate -i /docs/"$1" -l swagger -o /out
    return 0
  fi
}

swagger_ui_start() {
  local CONTAINER_NAME="${1:-swagger-ui-preview}"
  local TMP_DIR="/tmp/vim-swagger-preview/"
  if [[ ! "$(docker ps -q -f name=$CONTAINER_NAME)" ]]; then
    if [[ "$(docker ps -aq -f status=exited -f name=$CONTAINER_NAME)" ]]; then
      echo "$CONTAINER_NAME exited, cleaning"
      docker rm "$CONTAINER_NAME"
    fi
    docker run --name "$CONTAINER_NAME" -d -p 8017:8080 -e SWAGGER_JSON=/docs/swagger.json -v "$TMP_DIR":/docs swaggerapi/swagger-ui
  elif [[ "$(docker ps -aq -f status=running -f name=$CONTAINER_NAME)" ]]; then
    echo "$CONTAINER_NAME is already running"
  fi
}

swagger_preview() {
  local TMP_DIR="/tmp/vim-swagger-preview/"
  local LOG="${TMP_DIR}validate.log"
  local SOURCE="${1:-swagger.yaml}"
  if swagger_yaml2json "$SOURCE"; then
    swagger_ui_start
  else
    cat "$LOG"
    echo "Converting to json failed!"
  fi
}
