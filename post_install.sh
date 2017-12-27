#!/bin/bash

# TODO: set custom dns for the active connection with nmcli

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 
    exit 1
else
    # Gnome settings
    gsettings set org.gnome.nautilus.desktop trash-icon-visible false
    gsettings set org.gnome.desktop.interface show-battery-percentage true
    gsettings set org.gnome.desktop.interface clock-show-date true
    gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
    gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32

    # Update and Upgrade
    echo "# Updating and Upgrading"
    apt update && apt upgrade -y

    # Essentials
    echo "# Installing curl, dialog, git, htop, tree and vim"
    apt install -y curl dialog git htop tree vim
    cmd=(dialog --separate-output --checklist "Please Select Software you want to install:" 22 76 16)
    options=( # any option can be set to default to "on"
        1 "Gnome Tweak Tool" off
        2 "VLC Media Player" off
        3 "Visual Studio Code" off
        4 "KeePassXC" off
        5 "Gimp" off
        6 "VirtualBox" off
        7 "Docker" off
        8 "Zsh" off
        9 "NodeJS" off
        10 "Wireshark" off
        11 "Git Flow" off
    )
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    clear
    for choice in $choices
    do
        case $choice in
            1) # Gnome Tweak Tool
                echo "# Installing Gnome Tweak Tool"
                apt install -y gnome-tweak-tool
                ;;
            2) # VLC Media Player
                echo "# Installing VLC Media Player"
                apt install -y vlc
                ;;
            3) # Visual Studio Code
                echo "# Installing Visual Studio Code"
                curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
                mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
                add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
                apt update
                apt install -y code
                ;;
            4) # KeePassXC
                echo "# Installing KeePassXC"
                add-apt-repository -y ppa:phoerious/keepassxc
                apt update
                apt install -y keepassxc
                ;;
            5) # Gimp
                echo "Installing Gimp"
                apt update
                apt install -y gimp
                ;;
            6) # VirtualBox
                echo "# Installing VirtualBox"
                add-apt-repository "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"
                apt update
                apt install -y virtualbox
                apt install -y dkms
                # echo "debconf virtualbox-ext-pack/license seen true" | debconf-set-selections
                # echo "debconf virtualbox-ext-pack/license select true" | debconf-set-selections
                apt install -y virtualbox-ext-pack
                ;;
            7) # Docker
                echo "# Installing Docker"
                apt remove -y docker docker-engine docker.io
                apt install -y apt-transport-https ca-certificates curl software-properties-common
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
                apt-key fingerprint 0EBFCD88
                add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) edge"
                apt update
                apt install -y docker-ce
                groupadd docker
                usermod -aG docker $SUDO_USER
                ;;
            8) # Zsh
                echo "# Installing Zsh and Oh-My-Zsh"
                apt install -y zsh
                chsh -s $(which zsh) $SUDO_USER

                git clone git://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh"
                cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"
                ;;
            9) # NodeJS
                echo "# Installing NodeJS and Yarn"
                curl -sL https://deb.nodesource.com/setup_8.x | bash -
                apt install -y nodejs
                apt install -y build-essential

                curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
                add-apt-repository "deb [arch=amd64] https://dl.yarnpkg.com/debian/ stable main"
                apt update
                apt install -y yarn
                ;;
            10) # Wireshark
                echo "Installing Wireshark"
                # echo "debconf wireshark-common/install-setuid boolean true" | debconf-set-selections
                apt install -y wireshark
                groupadd wireshark
                usermod -aG wireshark $SUDO_USER
                ;;
            11) # Git Flow
                echo "Installing Git Flow"
                apt install -y git-flow
                ;;
        esac
    done
fi