#!/bin/bash

# Colors
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
WHITE=$(tput sgr0)

# Banner
banner="${BLUE}
  ___             ____  _   _ ____  
 / _ \ _ __   ___|  _ \| \ | / ___| 
| | | | '_ \ / _ \ | | |  \| \___ \ 
| |_| | | | |  __/ |_| | |\  |___) | | github karanveers969/cloudflare-dns-switcher
 \___/|_| |_|\___|____/|_| \_|____/  | V.2 (Cloudflare Only)${WHITE}\n"

# Check requirements
check_requirements() {
    if ! command -v curl &> /dev/null; then
        echo -e "${RED}Error: curl is not installed. Please install curl and try again.${WHITE}"
        exit 1
    fi
}

# Install the script system-wide
install_onedns() {
    current_script_path="$(realpath "$0")"
    install_path="/usr/local/bin/onedns"

    cp "$current_script_path" "$install_path" || {
        echo -e "\n${RED}Installation failed: Unable to copy the script.${WHITE}"
        exit 1
    }

    chmod +x "$install_path" || {
        echo -e "\n${RED}Installation failed: Cannot set execute permission.${WHITE}"
        exit 1
    }

    echo -e "\n${GREEN}Installation successful!${WHITE}"
    echo -e "${YELLOW}You can now run OneDNS from anywhere with: sudo onedns${WHITE}\n"
}

# Uninstall the script
uninstall_onedns() {
    echo -e "${YELLOW}Are you sure you want to uninstall OneDNS from your system?${WHITE}"
    read -p "Type 'yes' to confirm: " confirm
    if [[ "$confirm" == "yes" ]]; then
        if [[ -f "/usr/local/bin/onedns" ]]; then
            rm -f /usr/local/bin/onedns
            [[ -f "/etc/resolv.conf.onedns.bak" ]] && rm -f /etc/resolv.conf.onedns.bak
            echo -e "${GREEN}OneDNS and backup (if exists) have been removed.${WHITE}"
        else
            echo -e "${RED}OneDNS is not installed or already removed.${WHITE}"
        fi
        exit 0
    else
        echo -e "${GREEN}Uninstallation cancelled.${WHITE}"
    fi
}

# Change DNS to Cloudflare with backup
change_dns_to_cloudflare() {
    backup_file="/etc/resolv.conf.onedns.bak"

    if [[ ! -f "$backup_file" ]]; then
        cp /etc/resolv.conf "$backup_file"
        echo -e "${YELLOW}Backup created at $backup_file${WHITE}"
    fi

    echo -e "${YELLOW}Setting DNS to Cloudflare (1.1.1.1, 1.0.0.1)...${WHITE}"
    echo -e "nameserver 1.1.1.1\nnameserver 1.0.0.1" > /etc/resolv.conf
    echo -e "${GREEN}Cloudflare DNS successfully applied!${WHITE}\n"
}

# Restore DNS from backup
restore_backup_dns() {
    backup_file="/etc/resolv.conf.onedns.bak"
    if [[ -f "$backup_file" ]]; then
        cp "$backup_file" /etc/resolv.conf
        echo -e "${GREEN}Original DNS restored from backup.${WHITE}"
    else
        echo -e "${RED}No backup found. DNS has not been restored.${WHITE}"
    fi
}

# Intro panel
show_intro() {
    echo -e "$banner"
    echo -e "${GREEN}Welcome to OneDNS — Cloudflare DNS Switcher for Linux${WHITE}"
    echo -e "${YELLOW}Before proceeding, make sure you're connected to the internet and running this as root.${WHITE}"
    echo -e "${BLUE}--------------------------------------------------${WHITE}"
    echo -e "${BLUE}[${WHITE}1${BLUE}]${WHITE} Install (system-wide)\n${BLUE}[${WHITE}2${BLUE}]${WHITE} Use in Live mode (no install)\n${BLUE}[${WHITE}00${BLUE}]${WHITE} Exit${WHITE}"
    echo -e "${BLUE}--------------------------------------------------${WHITE}"
}

# Root check
if [[ "$(id -u)" -ne 0 ]]; then
    echo -e "\n${RED}Please run with sudo for installing or changing DNS.${WHITE}\n"
    exit 1
fi

# If script not yet installed system-wide
installed_path="/usr/local/bin/onedns"
if [[ "$(realpath "$0")" != "$installed_path" ]]; then
    check_requirements
    show_intro
    read -p "Select: " install_option

    case $install_option in
        1)
            install_onedns
            exit 0
            ;;
        2)
            echo -e "${GREEN}Running in live mode.${WHITE}\n"
            ;;
        00)
            echo -e "\n${YELLOW}Bye bye${WHITE}\n"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Exiting.${WHITE}\n"
            exit 1
            ;;
    esac
else
    echo -e "${GREEN}Running OneDNS from system path.${WHITE}\n"
fi

# Main menu
echo -e "$banner"
menu_options="${BLUE}[${WHITE}1${BLUE}]${WHITE} Apply Cloudflare DNS
${BLUE}[${WHITE}5${BLUE}]${WHITE} About
${BLUE}[${WHITE}6${BLUE}]${WHITE} Show Current DNS
${BLUE}[${WHITE}7${BLUE}]${WHITE} Restore Original DNS from Backup
${BLUE}[${WHITE}9${BLUE}]${WHITE} Uninstall OneDNS
${BLUE}[${WHITE}00${BLUE}]${WHITE} Exit${WHITE}\n"
echo -e "$menu_options"

while true; do
    read -p "Select: " i
    echo " "
    case $i in
        1)
            change_dns_to_cloudflare
            ;;
        5)
            echo -e "${GREEN}OneDNS is a lightweight DNS tool for Linux using only Cloudflare DNS. Developed by karanveers969 on GitHub.${WHITE}"
            ;;
        6)
            echo -e "${GREEN}$(cat /etc/resolv.conf)${WHITE}"
            ;;
        7)
            restore_backup_dns
            ;;
        9)
            uninstall_onedns
            ;;
        00)
            echo -e "\n${YELLOW}Bye bye${WHITE}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid command.${WHITE}"
            ;;
    esac
done


