#!/bin/bash

# BEGIN Functions 
# before the main program, because bash

function linuxFedora {
	echo Fedora Linux detected
	dnf check --assumeyes &&
	dnf autoremove --assumeyes &&
	dnf upgrade --assumeyes &&
	shutdown -r +5 "Applying Updates"
}

function linuxUbuntu {
	echo Ubuntu Linux detected
	/usr/bin/apt-get autoremove --yes &&
	/usr/bin/apt-get update --yes &&
	/usr/bin/apt-get dist-upgrade --yes &&
	/sbin/shutdown -r +5 "Rebooting to apply patches"

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
	machine=OSX
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
fi

# END Main
