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

h=()
if [[ -r ~/.ssh/config ]]; then
  h=($h ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
fi
if [[ -r ~/.ssh/known_hosts ]]; then
  h=($h ${${${(f)"$(cat ~/.ssh/known_hosts{,2} || true)"}%%\ *}%%,*}) 2>/dev/null
fi
if [[ $#h -gt 0 ]]; then
  zstyle ':completion:*:ssh:*' hosts $h
  zstyle ':completion:*:slogin:*' hosts $h
fi

# mkdir + cd
function mkdircd() {
	command mkdir $1 && cd $1
}

# kube-alias
function kubectl() { echo "+ kubectl $@">&2; command kubectl $@; }


# markdown table generator
function mdtable() {
  if [ $(uname -s) = "Darwin" ]; then
    command open -a "Google Chrome" ~/Tools/Markdown-Table-Generator/index.html
  fi
}

# curl cheat.sh
function cheat() {
  command curl cheat.sh/$1
}

# swagger-edit
function swagger-edit() {
	docker run -it --rm --volume="$(pwd)":/swagger -p 8080:8080 zixia/swagger-edit "$@"
}

# Swagger ui preview
# https://github.com/xavierchow/vim-swagger-preview
function swagger_yaml2json() {
  TMP_DIR="/tmp/vim-swagger-preview/"
  LOG=$TMP_DIR"validate.log"
  docker run --rm -v $(pwd):/docs rovecom/swagger-tools swagger-tools validate /docs/"$1" > $LOG 2>&1
  if [[ -s "$LOG" ]]; then
    # File exists and has a size greater than zero
    return 1
  else
    docker run -v "$(pwd)":/docs -v $TMP_DIR:/out swaggerapi/swagger-codegen-cli generate -i /docs/"$1" -l swagger -o /out
    return 0
  fi
}
function swagger_ui_start() {
    CONTAINER_NAME=${1:-swagger-ui-preview}
    TMP_DIR="/tmp/vim-swagger-preview/"
    # VOLUME=$(echo $(pwd) | tr "/" "_")
    if [ ! "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
        if [ "$(docker ps -aq -f status=exited -f name=$CONTAINER_NAME)" ]; then
            echo $CONTAINER_NAME "exited, cleaning"
            # cleanup
            # echo removing:
            docker rm $CONTAINER_NAME
        fi
        # run the container
        docker run --name $CONTAINER_NAME -d -p 8017:8080 -e SWAGGER_JSON=/docs/swagger.json -v $TMP_DIR:/docs swaggerapi/swagger-ui
    elif [ "$(docker ps -aq -f status=running -f name=$CONTAINER_NAME)" ]; then
            echo $CONTAINER_NAME "is already running"
    fi
}
function swagger_preview() {
    TMP_DIR="/tmp/vim-swagger-preview/"
    LOG=$TMP_DIR"validate.log"
    SOURCE=${1:-swagger.yaml}
    $(swagger_yaml2json $SOURCE)
    YAML2JSON_RETURN_CODE=$?
    if [ "$YAML2JSON_RETURN_CODE" -eq "0" ]; then
      swagger_ui_start
    else
      cat $LOG
      echo "Converting to json failed!"
    fi
}
