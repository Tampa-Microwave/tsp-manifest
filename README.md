# Tampa Microwave Yocto Manifest

This repository contains the manifest files used by the Android `repo` utilities used with Tampa Microwaves' Yocto distribution. It is a fork of Digi Embedded's Yocto distribution and their entire README is included at the end of this document.

## Quick Installation

Running the `./bootstrap.sh` script found in this repository will install system dependencies, download the sources, and setup an initial build directory. You'll need your `sudo` password and any ssh keys required for accessing Tampa Microwave private GitHub repositories.

### ssh keys

You need ssh access to download the Tampa Microwave specific repositories. Here is a great writeup on github.com to get you started: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent[github.com]

### Run the bootstrap script

Great. You have added your SSH key to github, you are ready to clone this github repository and run the `./bootstrap.sh` script to get your Yocto build system initialized.


```shell
$ git clone git@github.com:Tampa-Microwave/tsp-manifest.git
$ cd tsp-manifest
$ chmod +x ./bootstrap.sh
$ ./bootstrap.sh
```
Running the `./bootstrap.sh` script should take a few minutes to complete. The script, when complete, will prompt you to source the `tm-env` shell script. Run this script once every time you start a new terminal to work with Yocto.


