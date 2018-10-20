# update-o-matic

I wanted a single, cross-platform way to say "Apply all updates in a reasonably
safe and sane manner".  It seems like most update commands require several
discrete commands: clean up, update program database, ACTUALLY update, etc.
Over the years, I've written scripts for most of the operating systems that I
run at home. This is an effort to merge them into one script that can be pulled
down and run from any OS that supports bash.

I wanted scripts that could be run nightly from cron on servers, and scripts
that could be run by non-technical relatives on the desktop. Therefore, the
emphasis is on safety rather than efficiency.


## Requirements
1. The `bash` shell must be installed.
2. You must have the ability to run as root or equivalent (e.g. with `sudo`)
3. The `uname` command must exist
4. `git` is not required (you can download from github.com), but it's easier
   to stay up to date if it's installed.

## General update order
1. Update third-party repos or tools that run on top of the OS. Macports, etc.
   These are updated first because many OS updates require an immediate reboot,
   but it's rare for add-on packages to require a reboot.
2. Run any OS cleanup, fix, or check commands. If possible, the script should
   abort if a problem is found and not fixed.
3. Sync update databases and get list of possible updates.
4. Download and apply updates. Avoid experimental or not-recommended updates.
5. If reboot flag is set, reboot after 5 minutes.


## Supported Operating Systems (so far!)
* Linux variants
  * CentOS
  * Debian
  * Fedora
  * Raspbian
  * Redhat
  * OpenSuSE
  * Ubuntu
* Darwin (a.k.a. OS X)
  * with or without Macports
* FreeBSD with bash installed (but ports are NOT automatically updated
  at the moment)


## How to install and use
* go to whatever directory you use to store source code.
* To pull down the repository, type 
  `git clone https://github.com/brokengoose/update-o-matic.git` or 
  download the file
  `https://raw.githubusercontent.com/brokengoose/update-o-matic/master/update-o-matic.sh`
* To run the script, go to the update-o-matic directory and type 
   `sudo bash ./update-o-matic.sh`
* When it's time for updates,  go to the update-o-matic directory and type
  `git pull`
  or download the file from github again.

## Recent Changes

Shutdown wasn't finding the correct path when run from crontab. For now, I've hard coded it to /sbin/shutdown

## Known Issues

See https://github.com/brokengoose/update-o-matic/issues

