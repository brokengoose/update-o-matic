#!/bin/bash

# Set a reasonable default path for non-interactive (cron, etc.) use
PATH=$PATH:/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# BEGIN GlobalVariables

# Reboot by default. Can override with the "noreboot" command line option.
REBOOT=true
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

# END GlobalVariables

# BEGIN Functions 
# bash requires that functions be declared before they're used
# so this will build up from detailed functions to more abstract functions

function notSupported {
	echo "Unfortunately, this OS is not (or no longer) supported."
	echo "If you'd like to add support, please submit a request."
}

function executableFileExists {
	testFile=`which $1`
	if [ -x "$testFile" ]
	then
		echo Found $1
	else
		echo $1 does not exist. Please install it before continuing.
		echo It may be possible to search for this file with
		echo your package manager.
		exit
	fi
}

function rebootIfAllowed {
	if $REBOOT
	then
		shutdownCmd='/sbin/shutdown'
		if [ -x "$shutdownCmd" ]
		then
			$shutdownCmd -r +5 "Applying Updates."
		else
			echo No shutdown command found.
		fi
	else
		echo
		echo Please reboot as soon as possible.
	fi
}

function linuxAptGet {
	executableFileExists apt-get

	/usr/bin/apt-get autoremove --yes &&
	/usr/bin/apt-get update --yes &&
	/usr/bin/apt-get dist-upgrade --yes &&
	rebootIfAllowed
}

function linuxDnf {
	executableFileExists dnf

	dnf check --assumeyes &&
	dnf autoremove --assumeyes &&
	dnf upgrade --assumeyes &&
	rebootIfAllowed
}

function linuxYum {
	executableFileExists yum

	yum autoremove --assumeyes &&
	yum update --assumeyes &&
	rebootIfAllowed
}

function redhatVariant {
	# dnf seems to be the future direction for Redhat package management,
	# but yum is still used in Redhat and CentOS

	echo Redhat variant detected.
	
	if type dnf>/dev/null 2>&1
	then
		linuxDnf
	elif type yum>/dev/null 2>&1
	then
		linuxYum
	else
		Neither dnf nor yum found. Exiting.
		exit
	fi
}

function linuxDistroDetect {
	if type lsb_detect>/dev/null 2>&1
	then
		distro=`lsb_release -si`
	elif [ -f /etc/os-release ]
	then
		. /etc/os-release
		distro=$NAME
	elif [ -f /etc/lsb-release ]
	then
		. /etc/lsb-release
		distro=$DISTRIB_ID
	elif [ -f /etc/redhat-release ]
	then
		redhatVariant
	elif [ -f /etc/SuSE-release ]
	then
		suseVariant
	fi

	case $distro in
		CentOS*)	redhatVariant ;;
		Fedora*)	redhatVariant ;;
		Redhat*)	redhatVariant ;;

		Debian*)	linuxAptGet ;;
		Raspbian*)	linuxAptGet ;;
		Ubuntu*)	linuxAptGet ;;

       	        *)		echo Unknown Linux distribution $distro ;;
	esac

}

function darwinMacports {
	executableFileExists port

	echo Uninstalling inactive ports. A \"No ports matched\" error is okay.
	port uninstall inactive
	echo

	echo Updating Macports
	port selfupdate
	echo

	echo Upgrading outdated ports
	port upgrade outdated
	echo

}

function darwinOS {
	# Run port updates before OS updates
	# in case OS update requires an immediate reboot
	if type port>/dev/null 2>&1
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

# END Functions

# BEGIN Main

# This must be run with root privileges.
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with root privileges"
	exit 1
fi

# Grab command line argument
case $1 in
	reboot)		REBOOT=true ;;
	noreboot)	REBOOT=false ;;
	*)		echo Unknown argument $1 ;;
esac

executableFileExists uname
majorArch=`uname -s`;

case $majorArch in
	Linux)		linuxDistroDetect ;;
	Darwin)		darwinOS ;;
	*)		notSupported ;;
esac

# END Main
