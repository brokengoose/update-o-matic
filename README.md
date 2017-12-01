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
Darwin script does not. That could surprise desktop linux users. I should
probably add a flag, or at least, a prominent global variable.

Very few operating systems supported at this time. I have old scripts for old
versions of some other operating systems, but I need to be sure that they still
work correctly on current versions.

Script assumes that current update tools are in use. For example, dnf on Fedora.
For some operating systems, it might be necessary to dig more into versions
to determine which tool is most appropriate. I thought about falling back to
checking for rpm, deb, etc., but there are a lot of tools out there like alien
that make the situation complicated.


