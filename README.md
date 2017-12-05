# update-o-matic

I wanted a single, cross-platform way to say "Apply all updates in a reasonably
safe and sane manner".  It seems like most update commands require several
discrete commands: clean up, update program database, ACTUALLY update, etc.
Over the years, I've written scripts for most of the
operating systems that I run at home. This is an effort to merge them into
one script that can be pulled down and run from any OS that supports bash.

I wanted scripts that could be run nightly from cron on servers, and scripts
that could be run by non-technical relatives on the desktop. Therefore, the
emphasis is on safety rather than efficiency.


## Requirements
1. bash
2. ability to run as root (or equivalent, like sudo)
3. The uname command must exist

## General update order
1. Update third-party repos or tools that run on top of the OS. Macports, etc.
   These are updated first because many OS updates require an immediate reboot.
2. Run any OS cleanup, fix, or check commands. If possible, the script should
   abort if this step fails.
3. Sync update databases and get list of possible updates.
4. Download and apply updates. Avoid experimental or not-recommended updates.
5. If reboot flag is set, reboot after 5 minutes. In the warning message,
   give cancellation instructions, just in case anyone's using the server.


## Supported Operating Systems (so far!)
* Linux variants
  * CentOS
  * Debian
  * Fedora
  * Raspbian
  * Redhat
  * SuSE
  * Ubuntu
* Darwin (a.k.a. OS X)
  * with or without Macports
* FreeBSD with Ports and bash installed


## How to install and use
* go to whatever directory you use to store source code.
* To pull down the repository, type 
  `git clone https://github.com/brokengoose/update-o-matic.git` or just 
  download the file
  `https://raw.githubusercontent.com/brokengoose/update-o-matic/master/update-o-matic.sh`
* To run the script, go to the update-o-matic directory and type 
   `sudo bash ./update-o-matic.sh`
* When it's time for updates, type
  `cd update-o-matic; git pull`
  or download the file from github again.

## Recent Changes

I'm getting better with Git. Going forward, the "master" branch should be a lot more stable


## Known Issues

This is currently used and reasonably well tested in my own environment, but
I haven't tested as much in different environments or from pristine installs.
I've tried to ensure that there are checks and programs fail safely, but
I cannot ensure that.

