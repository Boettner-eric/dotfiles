#!/usr/bin/env zsh
set -e

# Copy a file to a destination, with a warning if the destination already exists
# safe_copy(source_file_path, destination_file_path)
safe_copy() {
    local src=$1
    local dest=$2
    if [[ -f $dest ]]; then
        print "\033[33mWarning: $dest already exists.\033[0m"
        read "response?Do you want to overwrite it? (y/N) "
        if [[ "$response" =~ ^[Yy]$ ]]; then
            cp $src $dest
            print "\033[33mFile overwritten.\033[0m"
        else
            print "\033[33mSkipping copy.\033[0m"
        fi
    else
        cp $src $dest
    fi
}

all() {
    zsh
    brew
    starship
}

brew() {
    # fetch homebrew from github
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # install brew packages from Brewfile
    brew bundle --file=./Brewfile
}

zsh() {
    # oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    safe_copy ./zsh/.zshrc ~/.zshrc
}

starship() {
    safe_copy ./zsh/starship.toml ~/.config/starship.toml
}

show_usage() {
    print "Usage: ${0:t} [-b] [-z] [-s]"
    print "Options:"
    print "  -b    Install brew packages"
    print "  -z    Install and configure oh-my-zsh"
    print "  -s    Configure starship"
    print "  -h    Show this help message"
    exit 1
}

typeset -A FLAGS=(
    a false
    s false
    b false
    c false
    z false
)

# Parse command line arguments
while getopts "bzs" opt; do
    case $opt in
        b) FLAGS[b]=true ;;
        z) FLAGS[z]=true ;;
        s) FLAGS[s]=true ;;
        h) show_usage ;;
        \?) show_usage ;;
    esac
done

# Check if at least one flag was provided
if [[ ${FLAGS[b]} == false && ${FLAGS[z]} == false && ${FLAGS[s]} == false ]]; then
    print "Error: No function flag provided" >&2
    show_usage
fi

# Execute functions based on flags
[[ ${FLAGS[b]} == true ]] && brew
[[ ${FLAGS[z]} == true ]] && zsh
[[ ${FLAGS[s]} == true ]] && starship
exit 0