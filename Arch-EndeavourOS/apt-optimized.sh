#!/bin/bash

# Variables
APP_VERSION="3.0-bash"
CALL_COMMAND="apt"
CONFIG_DIR="${HOME}/.aptpac"
CONFIG_FILE="${CONFIG_DIR}/config"
LEARN_MODE=0

# Functions
function help() {
    cat << EOF
USAGE:
    $CALL_COMMAND [option] [options for the option]
    EXAMPLE: $CALL_COMMAND search qemu
AVAILABLE OPTIONS:
    install         - install a package.
    install-local   - install local packages.
    remove          - uninstall a package.
    purge           - uninstall a package along with its configuration files.
    search          - search a package.
    find            - search for a file in packages.
    update          - update package lists.
    upgrade         - upgrade all packages.
    full-upgrade    - update + upgrade.
    autoclean       - clean up pacman caches.
    clean           - same as 'autoclean'.
    autoremove      - remove packages that are no longer needed.
    show            - show the information of an installed package.
    show-all        - show the information of a package from repos.
    list-installed  - list all installed packages.
    help            - show this help.
    version         - show version and about information.
SETTINGS:
    --learning-mode=<on|off> - toggle learning mode.
EOF
}

function about() {
    cat << EOF
      APTPAC
  ==============
A simple wrapper for pacman with a syntax similar to apt to help people transitioning to Arch and Arch-based distros like Manjaro.
Version: $APP_VERSION
License: MIT
(c) 2021 Itai Nelken
EOF
}

function config() {
    local action=$1
    local setting=$2
    local message=$3

    mkdir -p "$CONFIG_DIR"
    touch "$CONFIG_FILE"

    case "$action" in
        save)
            echo "$setting" >> "$CONFIG_FILE"
            [[ -n "$message" ]] && echo "$message"
            ;;
        delete)
            sed -i "/$setting/d" "$CONFIG_FILE"
            [[ -n "$message" ]] && echo "$message"
            ;;
        load)
            grep -q "$setting" "$CONFIG_FILE" && return 0 || return 1
            ;;
        load-all)
            cat "$CONFIG_FILE"
            ;;
        delete-all)
            > "$CONFIG_FILE"
            ;;
    esac
}

function run_command() {
    local cmd=$1
    shift
    [[ "$LEARN_MODE" == 1 ]] && echo -e "The command being run is: \e[1m$cmd \"$@\"\e[0m"
    eval "$cmd \"$@\""
}

# Main script logic
[[ -z "$1" ]] && { help; exit 1; }
[[ "$APTPAC_LEARN" == 1 ]] && LEARN_MODE=1

config load-all | grep -q "learn" && LEARN_MODE=1

while [[ -n "$1" ]]; do
    case ${1,,} in
        --learning-mode=*)
            mode=$(echo "$1" | cut -d'=' -f2)
            if [[ "$mode" == "on" ]]; then
                config save "learn"
                echo "Learning mode on"
            elif [[ "$mode" == "off" ]]; then
                config delete "learn"
                echo "Learning mode off"
            else
                echo -e "\e[31m\e[1mERROR:\e[0m\e[31m Invalid value '$mode' for --learning-mode!\e[0m"
            fi
            shift
            ;;
        --config)
            [[ "$2" == "clear" ]] && { config delete-all; echo "Configuration cleared successfully!"; exit 0; }
            echo -e "\e[31m\e[1mERROR:\e[0m\e[31m Invalid option '$2' for --config!\e[0m"
            shift
            ;;
        install)
            run_command "sudo pacman -S" "$@"
            shift
            ;;
        install-local)
            run_command "sudo pacman -U" "$@"
            shift
            ;;
        remove)
            run_command "sudo pacman -Rs" "$@"
            shift
            ;;
        purge)
            run_command "sudo pacman -Rn" "$@"
            shift
            ;;
        search)
            run_command "pacman -Ss" "$@"
            shift
            ;;
        find)
            run_command "pacman -F" "$@"
            shift
            ;;
        update)
            run_command "sudo pacman -Sy"
            shift
            ;;
        upgrade)
            run_command "sudo pacman -Su"
            shift
            ;;
        full-upgrade)
            run_command "sudo pacman -Syu"
            shift
            ;;
        autoclean|clean)
            run_command "sudo pacman -Scc"
            shift
            ;;
        autoremove)
            run_command "sudo pacman -Qdtq | sudo pacman -Rs -"
            shift
            ;;
        list-installed)
            run_command "pacman -Qqe"
            shift
            ;;
        show)
            run_command "pacman -Qi" "$@"
            shift
            ;;
        show-all)
            run_command "pacman -Si" "$@"
            shift
            ;;
        help|-h|--help|-help)
            help
            exit 0
            ;;
        version|-v|--version)
            about
            exit 0
            ;;
        *)
            echo -e "\e[1m\e[31mInvalid option \"$1\"!\e[0m"
            help
            exit 1
            ;;
    esac
done
