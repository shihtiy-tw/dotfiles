platform=$(uname)

if [ "${platform}" == "Darwin" ]; then
    echo "MacOS"
    OS="MacOS"

elif cat /etc/os-release | grep "^ID=" | grep -q 'ubuntu'; then
    echo "ubuntu"
    ./install-ubuntu.sh
    echo "Done"

elif cat /etc/os-release | grep "^ID=" | grep -q 'amzn'; then
    echo "amzn"
    OS="amzn"
    ./install-amazon-linux.sh
    echo "Done"
fi
