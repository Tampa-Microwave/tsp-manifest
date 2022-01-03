# Tampa Microwave Yocto Manifest

This repository contains the manifest files used by the Google `repo` utilities used with Tampa Microwaves' Yocto distribution. It is a fork of Digi Embedded's Yocto distribution and their entire README is included at the end of this document.

## Quick Installation

If you're on a new machine, the following command will install system dependencies, download the sources, and setup an initial build directory. You'll need your `sudo` password and any ssh keys required for accessing Tampa Microwave private GitHub repositories.

### ssh keys

You need ssh access to download the Tampa Microwave specific repositories. You need to do the following steps:

* Create an ssh key pair
* Create a github account
* Add your public ssh key to your github account
* Ask to be added to the Tampa-Microwave dev team in GitHub
* Run ssh-agent with your key:

        eval `ssh-agent -s`
        ssh-add

### Run the bootstrap script

This script should do everything up to kicking off the build.

```shell
bash -e <(curl -fsSL https://raw.githubusercontent.com/Tampa-Microwave/tm-manifest/zeus/bootstrap.sh)
```
