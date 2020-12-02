#!/bin/bash -e

# You'll need your sudo password and any ssh keys required by the repos inside
# the manifest file.

BUILD_PACKAGES="\
  build-essential \
  chrpath \
  cu \
  diffstat \
  g++-multilib \
  gawk \
  gcc-multilib \
  git-core \
  libsdl1.2-dev \
  minicom \
  socat \
  texinfo \
  unzip \
  wget \
  xterm \
"
sudo apt install -y ${BUILD_PACKAGES}

if ! which repo >/dev/null 2>&1; then
    printf "Installing Google repo tool...\n"
    sudo curl -o /usr/local/bin/repo http://commondatastorage.googleapis.com/git-repo-downloads/repo
    sudo chmod a+x /usr/local/bin/repo
fi

if ! git config --global user.name >/dev/null 2>&1; then
    read -ep "Name for git commits (e.g. Joe User): " GIT_NAME
    git config --global user.name "${GIT_NAME}"
fi
if ! git config --global user.email >/dev/null 2>&1; then
    read -ep "E-mail address for git commits (e.g. joe.user@domain.com): " GIT_EMAIL
    git config --global user.email "${GIT_EMAIL}"
fi
if ! git config --global color.ui >/dev/null 2>&1; then
    git config --global color.ui auto
fi

SOURCE_DIR=tm-3.0

mkdir ${SOURCE_DIR}
pushd ${SOURCE_DIR}
{
    repo init -u https://github.com/sr105-tm/tm-manifest.git -b zeus
    repo sync
    popd
}

mkdir -p build/ccimx6ulsbc
# no pushd/popd because we want to leave the user here
cd build/ccimx6ulsbc
source ../../${SOURCE_DIR}/sources/meta-tm-sw/conf/tm-env

# Local Variables:
# flyspell-mode: nil
# End:
