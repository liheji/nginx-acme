#!/bin/sh

# Check /cert is exist
if [ ! -d "/cert" ]; then
    mkdir -p /cert
fi

# Check init
if "/root/.acme.sh/acme.sh" --list | grep -q "$DOMAIN"; then
    echo "skip init"
else
    "/root/.acme.sh/acme.sh" --register-account -m "$EMAIL"
    "/root/.acme.sh/acme.sh" --set-default-ca --server zerossl
    "/root/.acme.sh/acme.sh" --issue --dns "$DNS"  -d "$DOMAIN" -d "*.$DOMAIN"
fi

# Execute
"/root/.acme.sh/acme.sh" --cron --home "/root/.acme.sh"
"/root/.acme.sh/acme.sh" --installcert -d "$DOMAIN" \
        --key-file /cert/"$DOMAIN".key \
        --fullchain-file /cert/"$DOMAIN".crt

nginx -g 'daemon off;'
