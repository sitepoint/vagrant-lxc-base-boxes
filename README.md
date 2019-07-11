# vagrant-lxc base boxes

This repository contains a set of scripts for creating base boxes for
usage with [vagrant-lxc](https://github.com/fgrehm/vagrant-lxc) 1.4+.

Older versions of vagrant-lxc may also work but have not been tested.

## What distros / versions can I build with this?

* Ubuntu
  - Xenial 16.04 x86_64
  - Wily 15.10 x86_64
  - Vivid 15.04 x86_64
  - Utopic 14.10 x86_64
  - Trusty 14.04 x86_64
  - Saucy 13.10 x86_64
  - Raring 13.04 x86_64
  - Quantal 12.10 x86_64
  - Precise 12.04 x86_64
* Debian
  - Sid x86_64
  - Buster x86_64
  - Stretch x86_64
  - Jessie x86_64
  - Wheezy x86_64
  - Squeeze x86_64
* Fedora
  - rawhide x86_64
  - 23 x86_64
  - 22 x86_64
  - 21 x86_64
  - 20 x86_64
  - 19 x86_64
* CentOS
  - 7 x86_64
  - 6 x86_64

## Building the boxes

_In order to build the boxes you need to have the `lxc-download`
template available on your machine. If you don't have one around please
create one based on [this](https://github.com/lxc/lxc/blob/master/templates/lxc-download.in)
and drop it on your lxc templates path (usually `/usr/share/lxc/templates`)._

```sh
git clone https://github.com/obnoxxx/vagrant-lxc-base-boxes.git
cd vagrant-lxc-base-boxes
make stretch
```

Additional packages to be installed can be specified with the ADDPACKAGES variable:

```sh
ADDPACKAGES="aptitude htop" \
make xenial
```

Will build a Ubuntu Xenial x86_64 box with aptitude and htop as additional
packages pre-installed. You can also specify the packages in a file
xenial_packages.

Note: ADDPACKAGES is currently only implemented for flavors of debian.

## Pre built base boxes

_**NOTE:** None of the base boxes below have a provisioner pre-installed_

| Distribution | VagrantCloud box |
| ------------ | ---------------- |
| Ubuntu Precise 12.04 x86_64 | [fgrehm/precise64-lxc](https://vagrantcloud.com/fgrehm/precise64-lxc) |
| Ubuntu Trusty 14.04 x86_64 | [fgrehm/trusty64-lxc](https://vagrantcloud.com/fgrehm/trusty64-lxc) |
| Debian Wheezy 7 x86_64 | [fgrehm/wheezy64-lxc](https://vagrantcloud.com/fgrehm/wheezy64-lxc) |
| Debian Jessie 8 x86_64 | [glenux/jessie64-lxc](https://atlas.hashicorp.com/glenux/boxes/jessie64-lxc) |
| CentOS 6 x86_64 | [fgrehm/centos-6-64-lxc](https://vagrantcloud.com/fgrehm/centos-6-64-lxc) |


## What makes up for a vagrant-lxc base box?

See [vagrant-lxc/BOXES.md](https://github.com/fgrehm/vagrant-lxc/blob/master/BOXES.md)


## Known issues

* We can't get the NFS client to be installed on the containers used for building
  Ubuntu 13.04 / 13.10 / 14.04 base boxes.
