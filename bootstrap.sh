#!/bin/bash -e

(return 0 2>/dev/null) && \
    printf "Don't source this script. Run it: \n\tbash -e ${BASH_SOURCE}\n" && \
    return 0 || \
    :

# You'll need your sudo password and any ssh keys required by the repos inside
# the manifest file.

install_build_packages() {
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
}

check_ssh_key_loaded() {
    # User must have loaded an ssh key that works with github
    if ! ssh-add -l >/dev/null 2>&1; then
        printf "You must start an ssh-agent with one key that works with github.\n"
        printf '\teval `ssh-agent -s`\n'
        printf '\tssh-add\n'
        return 1
    fi
}

ensure_a_python_exists() {
    # repo needs a "python" executable. some new systems don't have one
    if ! which python >/dev/null 2>&1; then
        PYTHON=$(which python3 || which python2)
        if [ "$PYTHON" == "" ]; then
            printf "Failed to find python, python3, or python2\n"
            return 1
        fi
        printf "Creating symlink: /usr/local/bin/python => ${PYTHON}\n"
        sudo ln -s "${PYTHON}" /usr/local/bin/python
    fi
}

install_github_ssh_key() {
    if ! grep -qE '^github\.com ssh-rsa ' ~/.ssh/known_hosts >/dev/null 2>&1; then
        mkdir -p ~/.ssh
        ssh-keyscan github.com >> ~/.ssh/known_hosts
        # Just in case we created the file and the directory
        chmod 700 ~/.ssh
        chmod 600 ~/.ssh/known_hosts
    fi
}

check_for_github_ssh_access() {
    local URL=ssh://git@github.com/Tampa-Microwave/meta-tm.git
    local GIT_SSH_COMMAND="ssh -q -o UserKnownHostsFile=/tmp/github_known_hosts"

    ssh-keyscan github.com > /tmp/github_known_hosts 2>/dev/null

    chmod 0 ~/.ssh
    if ! GIT_SSH_COMMAND="${GIT_SSH_COMMAND}" git ls-remote ${URL} >/dev/null 2>&1; then
        chmod 700 ~/.ssh
        printf "You must have a working ssh key loaded that can access \n"
        printf "the private Tampa Microwave repositories. You should be\n"
        printf "able to run this command without any interaction:\n"
        printf "\tgit ls-remote ${URL}\n"
        printf "\nSSH keys currently loaded:\n"
        ssh-add -l | sed 's/^/\t/'
        return 1
    fi
    chmod 700 ~/.ssh
    return 0
}

install_repo() {
    if ! which repo >/dev/null 2>&1; then
        printf "Installing Google repo tool...\n"
        sudo curl -o /usr/local/bin/repo http://commondatastorage.googleapis.com/git-repo-downloads/repo
        sudo chmod a+x /usr/local/bin/repo
    fi
}

ensure_git_user_exists() {
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
}

SOURCE_DIR=tm-3.0

download_sources() {
    mkdir -p ${SOURCE_DIR}
    pushd ${SOURCE_DIR} >/dev/null 2>&1
    {
        repo init -v -u https://github.com/Tampa-Microwave/tm-manifest -b zeus -m tsp.xml --depth=1
        repo sync
        popd >/dev/null 2>&1
    }
}

create_build_directory() {
    mkdir -p build/ccimx6ulsbc
    pushd build/ccimx6ulsbc >/dev/null 2>&1
    {
        echo
        echo
        source ../../${SOURCE_DIR}/sources/meta-tm/conf/tm-env >/dev/null
        popd >/dev/null 2>&1
    }
}

tell_next_steps() {
    printf "\n\nNow run this command:\n\tsource build/ccimx6ulsbc/tm-env\n\n"
}

install_build_packages
check_ssh_key_loaded
ensure_a_python_exists
install_github_ssh_key
check_for_github_ssh_access
install_repo
ensure_git_user_exists
download_sources
create_build_directory
tell_next_steps

# Local Variables:
# flyspell-mode: nil
# End:
