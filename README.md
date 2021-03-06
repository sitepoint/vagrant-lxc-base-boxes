# vagrant-lxc base boxes

This repository contains a set of scripts for creating Debian and
Ubuntu base boxes for usage with
[vagrant-lxc](https://github.com/fgrehm/vagrant-lxc) 1.4+ in
unprivileged mode.

Testing is mostly performed on Debian 10 (buster).

## What distros / versions can I build with this?

The boxes that can be built with this (and receive testing) are
limited to the following:

* Debian
  - Stretch x86_64
* Ubuntu
  - Xenial 16.04 x86_64

This list will be updated over time with newer stable releases (and
oldstable releases eventually dropped). If your distribution is not on
the list, you might instead be interested in the original
[vagrant-lxc-base-boxes](https://github.com/obnoxxx/vagrant-lxc-base-boxes)
project which this was forked from.

## Building the boxes

In order to build the boxes you need to have the `lxc-download`
template available on your machine (note: the `lxc` package included
in Debian 10 satisfies this requirement). Create one based on
[this](https://github.com/lxc/lxc/blob/master/templates/lxc-download.in)
template if required, and drop it on your lxc templates path (usually
`/usr/share/lxc/templates/`).

```sh
git clone https://github.com/sitepoint/vagrant-lxc-base-boxes.git
cd vagrant-lxc-base-boxes
make stretch
```

Additional packages to be installed can be specified with the ADDPACKAGES variable:

```sh
ADDPACKAGES="aptitude htop" \
make xenial
```

The above command will build a Ubuntu Xenial x86\_64 box with aptitude
and htop as additional packages pre-installed. You can also specify
the packages in a file xenial\_packages.

Unwanted packages can be removed via the REMPACKAGES variable should
the lxc-download template try to pull in something undesirable.


## Pre built base boxes

_**NOTE:** None of the base boxes below have a provisioner pre-installed_

| Distribution | VagrantCloud box |
| ------------ | ---------------- |
| Debian Buster 10 x86_64 | [debian-buster-amd64](https://app.vagrantup.com/sitepoint/boxes/debian-buster-amd64) |
| Debian Stretch 9 x86_64 | [debian-stretch-amd64](https://app.vagrantup.com/sitepoint/boxes/debian-stretch-amd64) |
| Ubuntu Xenial 16.04 x86_64 | [ubuntu-xenial-amd64](https://app.vagrantup.com/sitepoint/boxes/ubuntu-xenial-amd64) |


## What makes up for a vagrant-lxc base box?

See [vagrant-lxc/BOXES.md](https://github.com/fgrehm/vagrant-lxc/blob/master/BOXES.md)


## Known issues

* None, beside those related to running unprivileged LXC containers
  using vagrant-lxc
  (eg. https://github.com/fgrehm/vagrant-lxc/issues/485). If you are
  sure there is a bug in this project, please open an issue or submit
  a PR with as much information about the problem as possible so we
  may reproduce it.
