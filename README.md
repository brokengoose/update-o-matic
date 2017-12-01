# update-o-matic

I wanted a single, cross-platform way to say "Apply all updates in a reasonably
safe and sane manner". Over the years, I've written scripts for most of the
operating systems that I run at home. This is an effort to merge them into
one script that can be pulled down and run from any OS that supports bash.

I wanted scripts that could be run nightly from cron on servers, and scripts
that could be run by non-technical relatives on the desktop. Therefore, the
emphasis is on safety rather than efficiency.

## Supported Operating Systems
* Linux variants
  * Fedora
  * Ubuntu
* Darwin (a.k.a. OS X)
  * with or without Macports

## Known Issues

At the moment the Linux scripts automatically reboot after updating and the
Darwin script does not. This is because on the Linux machines, I run the script
nightly from cron. 

Very few operating systems supported.
