#!/bin/bash

# BEGIN Functions 
# before the main program, because bash

function linuxFedora {
	echo Fedora Linux detected
	dnf check --assumeyes &&
	dnf autoremove --assumeyes &&
	dnf upgrade --assumeyes &&
	shutdown -r +5 "Applying Updates. Cancel with shutdown -c"
}

function linuxUbuntu {
	echo Ubuntu Linux detected
	/usr/bin/apt-get autoremove --yes &&
	/usr/bin/apt-get update --yes &&
	/usr/bin/apt-get dist-upgrade --yes &&
	/sbin/shutdown -r +5 "Applying patches. Cancel with shutdown -c"

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

	echo Please read the messages above and reboot if needed.
}
# END Functions

# BEGIN Main

# This must be run with root privileges.
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root privileges"
	exit 1
fi


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
	distro=`lsb_release -si`
	case $distro in
	Fedora)
		linuxFedora
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
