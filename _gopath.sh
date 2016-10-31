#! /bin/bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
absPath=""

function unsetAll() {
	unset RED
	unset YELLOW
	unset NC
	unset absPath
}

function getAbsPath() {
	if [ ! -d $1 ]; then
		echo -e "[${RED}Error${NC}] Directory '${YELLOW}$1${NC}' not exists."
		return 1
	else
		oldDir=`pwd`
		cd $1
		absPath=`pwd`
		cd $oldDir
		return 0
	fi
}

function printHelp() {
	echo "* Usage:"
	echo -e "|----------------------------------------------------|"
	echo -e "|- gopath set xxx 		| set GOPATH to xxx  |"
	echo -e "|- gopath add xxx 		| add xxx to GOPATH  |"
	echo -e "|- gopath reset 		| set GOPATH to '${GREEN}/go${NC}'|"
	echo -e "|- gopath echo/p/print		| GOPATH             |"
	echo -e "|----------------------------------------------------|"
}

function printSucc() {
	echo -e "[${GREEN}Success${NC}] GOPATH="$GOPATH
}

function setGopath() {
	export GOPATH=$1
	printSucc
}


if [ -z "$1" ]; then
	printHelp
else
	if [ $1 == "print" ] || [ $1 == "echo" ] || [ $1 == "p" ] ; then
		printSucc
	else
		if [ $1 == "set" ]; then
			if [ -z "$2" ]; then
				absPath=`pwd`
			else
				getAbsPath $2
			fi

			if [ $? == 0 ]; then
				export GOPATH=$absPath
				printSucc
			fi
		elif [ $1 == "add" ]; then
			if [ -z "$2" ]; then
				absPath=`pwd`
			else
				getAbsPath $2
			fi

			if [ $? == 0 ]; then
				# 判断当前GOPATH是否已经包含该路径
				if [[ ":$GOPATH" != *":$absPath"* ]]; then
					export GOPATH=$GOPATH:$absPath
					printSucc
				else
					echo -e "[${YELLOW}Notice${NC}] '$absPath' is already in GOPATH"
				fi
			fi
		elif [ $1 == "reset" ]; then
			export GOPATH=/go
			printSucc
		else
			echo -e "[${RED}Error${NC}] Invalid command '${YELLOW}$1${NC}'. Check help:"
			printHelp
		fi
	fi
fi
unsetAll




