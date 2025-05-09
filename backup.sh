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
    backup_starship
    backup_zsh
}

backup_starship() {
    print "Backing up starship config"
    safe_copy ~/.config/starship.toml ./zsh/starship.toml
}

backup_zsh() {
    print "Backing up zsh config"
    safe_copy ~/.zshrc ./zsh/.zshrc
}

show_usage() {
    print "Usage: ${0:t} [-a] [-s] [-z]"
    print "Options:"
    print "  -a    Backup all configs"
    print "  -s    Backup starship config"
    print "  -z    Backup zsh config"
    print "  -h    Show this help message"
    exit 1
}

typeset -A FLAGS=(
    a false
    s false
    z false
)

# Parse command line arguments
while getopts "hasz" opt; do
    case $opt in
        a) FLAGS[a]=true ;;
        s) FLAGS[s]=true ;;
        z) FLAGS[z]=true ;;
        h) show_usage ;;
        \?) show_usage ;;
    esac
done

# Check if at least one flag was provided
if [[ ${FLAGS[a]} == false && ${FLAGS[s]} == false && ${FLAGS[z]} == false ]]; then
    print "Error: No function flag provided" >&2
    show_usage
fi

# Execute functions based on flags
[[ ${FLAGS[a]} == true ]] && all
[[ ${FLAGS[s]} == true ]] && backup_starship
[[ ${FLAGS[z]} == true ]] && backup_zsh

exit 0