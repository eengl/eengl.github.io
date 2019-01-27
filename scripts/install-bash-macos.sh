#!/bin/sh
#set -x

# ---------------------------------------------------------------------------------------- 
# ---------------------------------------------------------------------------------------- 
BASH_URL="http://ftp.gnu.org/gnu/bash/"

# ---------------------------------------------------------------------------------------- 
# ---------------------------------------------------------------------------------------- 
function get_bash_versions()
{
    printf "%s" " - Obtaining available Bash versions... "
    curl -s $BASH_URL --list-only | \
    grep 'bash-[0-9]*.[0-9]*.[0-9]*.tar.gz' | \
    grep ".tar.gz<" | \
    cut -d"=" -f 5 | \
    cut -d">" -f 1 |
    sed 's/\"//g' |
    sort -V > bash-files.txt
    printf "%s\n" "Done"
}

# ---------------------------------------------------------------------------------------- 
# ---------------------------------------------------------------------------------------- 
function select_bash_version()
{
    echo " - Available Bash Versions: "
    for f in $(cat bash-files.txt)
    do
        printf "   %s\n" $(echo $f | cut -d"-" -f 2 | sed 's/\.tar\.gz//g')
    done
    read -p " - Select the version to install: " version_to_install
}

# ---------------------------------------------------------------------------------------- 
# ---------------------------------------------------------------------------------------- 
function build_bash()
{
    tar -xzvf $file
    cd $(basename $file .tar.gz)
    mkdir build && cd build
    read -p " - Set installation path [default: /usr/local]: " prefix
    ../configure --prefix=$prefix
    make -j 2
    sudo make install
}

# ---------------------------------------------------------------------------------------- 
# ---------------------------------------------------------------------------------------- 
cd $(mktemp -d)
get_bash_versions
select_bash_version
echo $version_to_install
file="bash-$version_to_install.tar.gz"
curl -O $BASH_URL$file
build_bash