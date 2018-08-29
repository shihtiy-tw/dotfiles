#!/bin/bash
#===============================================================================
#
#          FILE:  dofiles.sh
#
#         USAGE:  ./dofiles.sh
#
#   DESCRIPTION:  backup the dotfiles
#
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#       VERSION:  1.0
#       CREATED:  2018年08月28日 星期二 01時03分34秒 EDT EDT
#      REVISION:  ---
#===============================================================================

source ./config.sh
source ./functions.sh
source ./greeting.sh

shopt -s expand_aliases
#https://unix.stackexchange.com/questions/1496/why-doesnt-my-bash-script-recognize-aliases


# uppercase to lowercase
selection=${1,,}
case ${selection} in
	"init")
		setting_up init
		add_commit
		;;
	"backup")
		add_commit
		;;
	"install")
		setting_up clone
		install
		;;
	*)
		echo "usage ${0} {init|backup|install}"
		;;
esac
