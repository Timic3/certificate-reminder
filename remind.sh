#!/bin/bash

source .env

for pem in $CERT_PATH; do
    DOMAIN=$(basename $(dirname $pem))
    EXPIRATION_DATE=$(date --date="$(openssl x509 -enddate -noout -in $pem | cut -d= -f 2)" '+%d. %B %Y %H:%M:%S %Z')

    echo "$DOMAIN: $EXPIRATION_DATE"

    if [[ ! $* == *--dry-run* ]]; then
        curl \
            -H "Content-Type: application/json" \
            -d "{\"content\": \":warning: Domain **$DOMAIN** expires at **$EXPIRATION_DATE**.\"}" \
            $WEBHOOK_URL
    fi
done
