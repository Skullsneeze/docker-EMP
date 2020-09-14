#!/bin/bash

helpDialog="
╔═╗╦═╗╔═╗  ╔═╗╔═╗╔╦╗╔═╗╔═╗╔═╗╔═╗
╠═╝╠╦╝║╣───║  ║ ║║║║╠═╝║ ║╚═╗║╣
╩  ╩╚═╚═╝  ╚═╝╚═╝╩ ╩╩  ╚═╝╚═╝╚═╝

Making docker-compose that bit more awesome.
---------------------------------------------------------------------------------

Usage:
$(basename "$0") [-h|--help] [-u|--no-ssl] [-v|--verbose]

Arguments:
    -h|--help       Display this help dialog.
    -s|--ssl        Generate SSL certificate.
    -m|--mage       Run commands to ensure Magento can run properly.

NOTE:
The .env file that is used for docker is also used to supply variables for this script.
"

# Verify dependencies
command -v mkcert >/dev/null 2>&1 || { echo >&2 "The mkcert command is needed for SSL generation. Please make sure you have it installed. more information: https://mkcert.dev/"; exit 1; }

# Initialize local vars
text_seperator="
────────────────────────────────────
";
generate_cert=0
prepare_mage=0

# Gather params
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -s|--ssl)
    generate_cert=1
    shift
    ;;
    -m|--mage)
    prepare_mage=1
    shift
    ;;
    -h|--help)
    echo "$helpDialog"
    exit;
    ;;
    *) # unknown argument
    echo "$1" is not a valid argument
    echo ""
    echo "$helpDialog"
    exit;
    ;;
esac
done

echo -e "$text_seperator";

# Export vars defined in .env
if [ -f "$PWD/.env" ]; then
    set -o allexport
    source "$PWD/.env"
    set +o allexport
else
    echo "No .env file has been found. Please make sure you have you supply a .env file within the current directory."
fi

# SSL generation
if [ $generate_cert -eq 1 ]; then
    cert_dir="$PWD/certs"
    if [ ! -f "$cert_dir/$SERVER_NAME.pem" ] || [ ! -f "$cert_dir/$SERVER_NAME-key.pem" ]; then
        echo "Generating SSL certificate for $SERVER_NAME in $cert_dir";
        mkcert -cert-file "/$SERVER_NAME".pem -key-file "$cert_dir/$SERVER_NAME"-key.pem "$SERVER_NAME";
    else
        echo "SSL Certificate already generated.";
    fi
    echo -e "$text_seperator";
else
  printf  "Skipping SSL certificate generation";
  echo -e "$text_seperator";
fi

# Magento preparation
if [ $prepare_mage -eq 1 ]; then
    mage_dir="$PWD/..";
    echo "Preparing Magento folders. Some actions will require \`sudo\` permissions";
    sudo chmod -R 777 "$mage_dir/var";
    sudo chmod -R 777 "$mage_dir/pub";

    echo -n "Cleanup generated files? [y/n]: "
    read -r cleanup_generated;
    if [ "$cleanup_generated" == "y" ]; then
        sudo rm -rf "$mage_dir/generated";
        echo "Cleaned up generated files.";
    fi
    echo -e "$text_seperator";
fi

echo "All done!";
