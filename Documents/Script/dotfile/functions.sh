function setting_up(){

	while [ -e $HOME/${bare_repository} ]; do
		echo "This directory ${dotfile} already exits..."
		read -p "input a directory to be your bare repository: " bare_repository
	done
	echo "$HOME/${bare_repository} will be your bare repository for your config files"
	mkdir $HOME/${bare_repository}

	if [ ! -e /usr/bin/git ]; then
		echo "please download git"
		exit 1
	fi

	if [ ${1,,} == "init" ]; then
		git init --bare "$HOME/${bare_repository}"
	elif [ ${1,,} == "clone" ]; then
		git clone --bare $github_repository_https_url "$HOME/${bare_repository}"
	else
		echo 'what'
	fi


	flag="1"
	while [ flag == "1" ]; do
		alias | cut -d ' ' -f 2 | cut -d '=' -f 1 | grep config && echo "you already alias config, please check if you want to rewrite the config alias" || flag="0"
		read -p "input a command name to be the alias to do git things for your bare repository: " config_keyword
	done
	echo "config_keyword=$config_keyword" >> ./config.sh

	alias ${config_keyword}="/usr/bin/git --git-dir=$HOME/$bare_repository/ --work-tree=$HOME"
	echo ${config_keyword}"=/usr/bin/git --git-dir=$HOME/$bare_repository/ --work-tree=$HOME">> $HOME/.bashrc
}

function add_commit(){
	alias ${config_keyword}="/usr/bin/git --git-dir=$HOME/$bare_repository/ --work-tree=$HOME"
	for file in ${dotfiles[@]}; do
		if [ -e $HOME/${file} ]; then
			eval ${config_keyword} add "$HOME/${file}"
			eval ${config_keyword} commit -m "${file}"
		fi
	done

	remote=$(eval ${config_keyword} remote)
	if [ $remote != "origin" ]; then
		echo $remote
		if [ $USER == 'ieni' ]; then
			eval ${config_keyword} remote add origin ${github_repository_https_url}
		else
			eval ${config_keyword} remote add origin ${github_repository_ssh_url}
		fi
	fi
	eval ${config_keyword} push origin master
}

function install(){
	mkdir -p $HOME/.config-backup
	eval ${config_keyword} checkout
	if [ $? = 0 ]; then
		echo "Checked out config.";
	else
		echo "Backing up pre-existing dot files.";
		eval ${config_keyword} checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv $HOME/{} $HOME/.config-backup/{}
	fi
	eval ${config_keyword} checkout
	eval ${config_keyword} config status.showUntrackedFiles no
}
