# Docker EMP
A simple Nginx, PHP-FPM, Mysql docker stack

[![Status - WIP](https://img.shields.io/badge/status-WIP-yellow.svg)](https://shields.io/)
[![PR's welcome](https://img.shields.io/badge/PR's-Welcome!-green.svg)](https://shields.io/)
[![MIT license](https://img.shields.io/github/license/Naereen/StrapDown.js.svg)](https://github.com/Naereen/StrapDown.js/blob/master/LICENSE)


## Prerequisites
To get started with this docker stack, you will need a few things.

### Dockerized
Make sure you are running the [Dockerized](https://github.com/Skullsneeze/dockerized) container. This will route the traffic for all your docker services.
 
### Local HTTPS with mkcert
Make sure you have `mkcert` (https://mkcert.dev/) installed, and generate the local CA by running `mkcert -install`.

### Automatic local domain resolving
Makes ure dnsmasq is installed. This tool will help us redirect all docker traffic to our localhost.

**Installing dnsmasq**
For MacOS (with homebrew): `brew install dnsmasq`

For Ubuntu 18.04:
- Disable default resolver
```
sudo systemctl disable systemd-resolved && \
sudo systemctl stop systemd-resolved;
```
- Backup and Remove default resolver config
```
sudo cp /etc/resolv.conf ~/resolv.conf.bck && rm /etc/resolv.conf
```
- Create a new resolver config
```
echo "nameserver 8.8.8.8" > /etc/resolv.conf
```
- Install dnsmasq extension
```
sudo apt update && sudo apt install dnsmasq
```

**Configure to redirect docker.localhost domains**
For mac:
- Create a resolver directory
```
sudo mkdir -p /etc/resolver
```
- Write to a new configuration file
```
sudo tee /etc/resolver/docker.localhost > /dev/null <<EOF
nameserver 127.0.0.1
domain docker.localhost
search_order 1
EOF
```

For Ubuntu 18.04:
_Coming soon_

## Getting started

### Clone this repo
To use the docker stack, clone this repo into a new folder in the root of your project.
```
mkdir docker && \
git clone https://github.com/Skullsneeze/docker-EMP.git docker
```

### .env file
Some important information should be made available with the use of an environment file (.env). You can simply copy the existing sample file and modify the variables to match your project.
```
cp .env.sample .env
```

### Pre-compose
The pre-compose.sh script is a little tool that will help to set up things like certificates and folder permissions where needed.
To use the script, first make sure it is executable.
```
chmod +x ./pre-compose.sh
```
To see what you can do with the script, you can run the command with the help parameter.
```
./pre-compose.sh --help
```

### Running the services
To run the services, simply run `docker-compose up -d`. Once this is done, you should be able to visit your project by browsing to the URL you specified in you .env file.

## Additional Notes
The current configuration is based on a Magento 2 installation. Things like the php configuration and nginx configuration might need to be adapted to fit your needs.

[![ForTheBadge built-with-love](http://ForTheBadge.com/images/badges/built-with-love.svg)](https://GitHub.com/Naereen/)
