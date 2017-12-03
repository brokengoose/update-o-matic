#!/bin/bash

# BEGIN GlobalVariables

REBOOT=false

# END GlobalVariables

# BEGIN Functions 
# before the main program, because bash

function executableFileExists {
	if [ ! -f `which $1` ]
	then
		echo $1 does not exist. Please install it before continuing.
		echo Your package manager may have a way to search for this file
		exit
	fi
}

function rebootIfAllowed {
	if $REBOOT
	then
		if [ -f `which shutdown` ]
		then
			shutdown -r +5 "Applying Updates. Cancel with shutdown -c"
		else
			echo No shutdown command found.
		fi
	else
		echo Be sure that you do not need to reboot.
	fi
}


function linuxDnf {
	executableFileExists dnf

	echo dnf detected
	dnf check --assumeyes &&
	dnf autoremove --assumeyes &&
	dnf upgrade --assumeyes &&
	rebootIfAllowed
}

function linuxAptGet {
	executableFileExists apt-get

	echo Updating using apt-get
	/usr/bin/apt-get autoremove --yes &&
	/usr/bin/apt-get update --yes &&
	/usr/bin/apt-get dist-upgrade --yes &&
	rebootIfAllowed
}

function darwinMacports {

	# Just in case someone forgot to check for the port executable
	command -v port || exit

	echo Uninstalling inactive ports. A \"No ports matched\" error is okay.
	port uninstall inactive
	echo

	echo Updating Macports
	port selfupdate || exit
	echo

	echo Upgrading outdated ports
	port upgrade outdated || exit
	echo

}

function darwinOS {
	# Run port updates before OS updates
	# in case OS update requires an immediate reboot
	if [ `command -v port` ]
	then
		darwinMacports
	fi

	echo Running periodic scripts
	periodic daily weekly monthly || exit
	echo

	echo Updating the OS
	softwareupdate --install --recommended || exit
	echo

	rebootIfAllowed
}

function linuxFedora {
	echo Fedora detected.
	
	if [ -f `which dnf` ]
	then
		linuxDnf
	elif [ -f `which yum` ]
	then
		echo You are using Yum, which is not yet supported.
	else
		Weird. Neither dnf nor yum found. 
	fi
}

function linuxUbuntu {
	echo Ubuntu detected.

	if [ -f `which dnf` ]
	then
		linuxAptGet
	else
		Weird. apt-get is not installed. Cannot continue.
		exit.
	fi
}

# END Functions

# BEGIN Main

# This must be run with root privileges.
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root privileges"
	exit 1
fi

executableFileExists uname
majorArch=`uname -s`;

case $majorArch in
Linux*)
	machine=Linux
	;;
Darwin*)
	machine=Darwin
	;;
*)
	machine="UNKNOWN:$majorArch"
	;;
esac

if [ $majorArch = "Linux" ];
then

	echo Linux detected.

	executableFileExists lsb_release
	distro=`lsb_release -si`

	case $distro in
	Fedora) linuxFedora
		;;
	Ubuntu)
		linuxUbuntu
		;;
	*)
		echo Unknown Linux distribution
		;;
	esac

elif [ $majorArch = "Darwin" ];
then
	darwinOS
else
	echo I am not sure what to do here.

fi

# END Main
