# Dockerfile

# Script       : IP-Tracker
# Author       : KasRoudra
# Github       : https://github.com/KasRoudra
# Messenger    : https://m.me/KasRoudra
# Email        : kasroudrakrd@gmail.com
# Date         : 10-09-2021
# Main Language: Shell

# Download and import main images

# Operating system
FROM debian:latest

# Author info
LABEL MAINTAINER="https://github.com/KasRoudra/IP-Tracker"

# Working directory
WORKDIR /IP-Tracker/
# Add files 
ADD . /IP-Tracker

# Installing other packages
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install curl unzip wget -y
RUN apt-get install --no-install-recommends php -y
RUN apt-get clean

# Main command
CMD ["./ip.sh", "--no-update"]

## Wanna run it own? Try following commnads:

## "sudo docker build . -t kasroudra/ip-tracker:latest", "sudo docker run --rm -it kasroudra/ip-tracker:latest"

## "sudo docker pull kasroudra/ip-tracker", "sudo docker run --rm -it kasroudra/ip-tracker"
