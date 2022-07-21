<h2 align="center"><u>IP-Tracker</u></h2>

![IP-Tracker](https://github.com/KasRoudra/IP-Tracker/raw/main/files/banner.png)
<h4 align="center"> Track IP with tricky link! </h4>

<p align="center">
    <img src="https://img.shields.io/badge/Version-1.4-blue?style=for-the-badge&color=blue">
    <img src="https://img.shields.io/github/stars/KasRoudra/IP-Tracker?style=for-the-badge&color=magenta">
    <img src="https://img.shields.io/github/forks/KasRoudra/IP-Tracker?color=cyan&style=for-the-badge&color=purple">
    <img src="https://img.shields.io/github/issues/KasRoudra/IP-Tracker?color=red&style=for-the-badge">
    <img src="https://img.shields.io/github/license/KasRoudra/IP-Tracker?style=for-the-badge&color=blue">
<br>
    <img src="https://img.shields.io/badge/Author-KasRoudra-magenta?style=flat-square">
    <img src="https://img.shields.io/badge/Open%20Source-Yes-orange?style=flat-square">
    <img src="https://img.shields.io/badge/Maintained-Yes-cyan?style=flat-square">
    <img src="https://img.shields.io/badge/Written%20In-Shell-purple?style=flat-square">
</p>

### [+] Description
IP-Tracker is a tool that simply take a website as input and generate a phishing link. That phishing link looks normal; if anyone opens the link his/her ip will be captured and he/she will be redirected to the website taken as input.

### [+] Installation
 - `git clone https://github.com/KasRoudra/IP-Tracker`
 - `cd IP-Tracker`
 - `bash ip.sh`

##### Or run directly
```
wget https://raw.githubusercontent.com/KasRoudra/IP-Tracker/main/ip.sh && bash ip.sh
```

### [+] Features
 - Tricky link
 - Concurrent triple tunneling (Ngrok, Cloudflared and Loclx)
 - Redirect to website according to wish
 - Get many details along with ip like location, geolocation

### Docker

 - `sudo docker pull kasroudra/ip-tracker`
 - `sudo docker run --rm -it kasroudra/ip-tracker`

### [+] Previews

##### Waiting for victim to open link
![before](https://github.com/KasRoudra/IP-Tracker/raw/main/files/before.jpg)

##### After victim opened link
![after](https://github.com/KasRoudra/IP-Tracker/raw/main/files/after.jpg)


### [+] Dependencies
 - `php`
 - `wget`
 - `curl`
 - `unzip`

## [*] Usage

```
Usage: bash ip.sh [-h] [-o OPTION] [-U URL] [-p PORT] [-t TUNNELER] [-u] [-nu]

Options:
  -h, --help                           Show this help message and exit
  -o OPTION, --option OPTION           Index of the template
  -p PORT, --port PORT                 Port of IP-Tracker's Server
  -t TUNNELER, --tunneler TUNNELER     Name of the tunneler for url shortening
  -U URL, --url URL                    URL to be redirected
  --update(-u), --no-update (-nu)      Check for update (Default: true)
```

All necessary dependencies will be automatically installed on first run!

### [+] Disclaimer 
***This tool is developed for educational purposes. Here it demonstrates how ip-trackers work. If anybody wants to gain unauthorized access to someones IP-Address, he/she may try out this at his/her own risk. You have your own responsibilities and you are liable to any damage or violation of laws by this tool. The author is not responsible for any misuse of IP-Tracker!***

## [~] Find Me on :

- [![Github](https://img.shields.io/badge/Github-KasRoudra-green?style=for-the-badge&logo=github)](https://github.com/KasRoudra)

- [![Gmail](https://img.shields.io/badge/Gmail-KasRoudra-green?style=for-the-badge&logo=gmail)](mailto:kasroudrakrd@gmail.com)

- [![Facebook](https://img.shields.io/badge/Facebook-KasRoudra-green?style=for-the-badge&logo=messenger)](https://facebook.com/KasRoudra)

- [![Messenger](https://img.shields.io/badge/Messenger-KasRoudra-green?style=for-the-badge&logo=messenger)](https://m.me/KasRoudra)


