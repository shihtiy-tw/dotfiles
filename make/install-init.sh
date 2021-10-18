platform=$(uname)

if [ "${platform}" == "Darwin" ]; then
    echo "MacOS"
    OS="MacOS"

elif cat /etc/os-release | grep "^ID=" | grep -q 'ubuntu'; then
    echo "ubuntu"
    ${HOME}/dotfiles/make/install-ubuntu.sh
    echo "Done"

elif cat /etc/os-release | grep "^ID=" | grep -q 'amzn'; then
    echo "amzn"
    OS="amzn"
    ${HOME}/dotfiles/make/install-amazon-linux.sh
    echo "Done"
fi
