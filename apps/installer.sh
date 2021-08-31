#! /bin/bash

b='\033[1m'
r='\E[31m'
g='\E[32m'
c='\E[36m'
endc='\E[0m'
enda='\033[0m'

clear

# Change default shell from sh to bash
sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd

# Initialisation of Installer
printf "\n\n$c$b    Loading Installer $endc$enda" >&2
if sudo apt-get update &> /dev/null
then
    printf "\r$g$b    Installer Loaded $endc$enda\n" >&2
else
    printf "\r$r$b    Error Occured $endc$enda\n" >&2
    exit
fi

# Install Desktop Environment (XFCE4)
printf "$g$b    Installing Desktop Environment $endc$enda" >&2
{
    sudo DEBIAN_FRONTEND=noninteractive \
        apt install --assume-yes xfce4 desktop-base xfce4-terminal
    sudo bash -c 'echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session'
    sudo apt remove --assume-yes gnome-terminal  
    sudo apt install --assume-yes xscreensaver
    sudo systemctl disable lightdm.service
} &> /dev/null &&
printf "\r$c$b    Desktop Environment Installed $endc$enda\n" >&2 ||
{ printf "\r$r$b    Error Occured $endc$enda\n" >&2; exit; }



# Install Google Chrome
printf "$g$b    Installing Google Chrome $endc$enda" >&2
{
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg --install google-chrome-stable_current_amd64.deb
    sudo apt install --assume-yes --fix-broken
} &> /dev/null &&
printf "\r$c$b    Google Chrome Installed $endc$enda\n" >&2 ||
printf "\r$r$b    Error Occured $endc$enda\n" >&2



# Install CrossOver (Run exe on linux)
printf "$g$b    Installing CrossOver $endc$enda" >&2
{
    wget https://media.codeweavers.com/pub/crossover/cxlinux/demo/crossover_20.0.4-1.deb
    sudo dpkg -i crossover_20.0.4-1.deb
    sudo apt install --assume-yes --fix-broken
} &> /dev/null &&
printf "\r$c$b    CrossOver Installed $endc$enda\n" >&2 ||
printf "\r$r$b    Error Occured $endc$enda\n" >&2


# Install VLC Media Player 
printf "$g$b    Installing VLC Media Player $endc$enda" >&2
{
    sudo apt install vlc -y
} &> /dev/null &&
printf "\r$c$b    VLC Media Player Installed $endc$enda\n" >&2 ||
printf "\r$r$b    Error Occured $endc$enda\n" >&2

# Install other tools like nano
sudo apt-get install gdebi -y &> /dev/null
sudo apt-get install vim -y &> /dev/null
printf "$g$b    Installing other Tools $endc$enda" >&2
if sudo apt install nautilus nano -y &> /dev/null
then
    printf "\r$c$b    Other Tools Installed $endc$enda\n" >&2
else
    printf "\r$r$b    Error Occured $endc$enda\n" >&2
fi


printf "\n$g$b    Installation Completed $endc$enda\n\n"
