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
    fetch_starship
    fetch_zsh
    function_b
    function_c
}


fetch_starship() {
    print "Fetching starship config"
    safe_copy ~/.config/starship.toml ./zsh/starship.toml
}

fetch_zsh() {
    print "Saving zsh config"
    safe_copy ~/.zshrc ./zsh/.zshrc
}

function_b() {
    print "Executing function B"
    # Add your function B logic here
}

function_c() {
    print "Executing function C"
    # Add your function C logic here
}

show_usage() {
    print "Usage: ${0:t} [-s] [-b] [-c]"
    print "Options:"
    print "  -s    Save starship config"
    print "  -b    Execute function B"
    print "  -c    Execute function C"
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
while getopts "zasbch" opt; do
    case $opt in
        a) FLAGS[a]=true ;;
        s) FLAGS[s]=true ;;
        b) FLAGS[b]=true ;;
        c) FLAGS[c]=true ;;
        z) FLAGS[z]=true ;;
        h) show_usage ;;
        \?) show_usage ;;
    esac
done

# Check if at least one flag was provided
if [[ ${FLAGS[a]} == false && ${FLAGS[s]} == false && ${FLAGS[b]} == false && ${FLAGS[c]} == false && ${FLAGS[z]} == false ]]; then
    print "Error: No function flag provided" >&2
    show_usage
fi

# Execute functions based on flags
[[ ${FLAGS[a]} == true ]] && all
[[ ${FLAGS[s]} == true ]] && fetch_starship
[[ ${FLAGS[z]} == true ]] && save_zsh
[[ ${FLAGS[b]} == true ]] && function_b
[[ ${FLAGS[c]} == true ]] && function_c

exit 0