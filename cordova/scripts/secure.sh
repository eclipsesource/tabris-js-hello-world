#!/usr/bin/env bash

set -e

if [[ "$VERBOSE" = true || $VERBOSE -eq 1 ]]; then
	set -x
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

openssl enc -d -base64 -in $DIR/sign_and_encrypt.sh.enc.base64 -out sign_and_encrypt.sh.enc
openssl enc -d -aes-256-cbc -md md5 -k $SIGN_AND_ENCRYPT_ENCRYPTION_KEY -in sign_and_encrypt.sh.enc -out sign_and_encrypt.sh

source ./sign_and_encrypt.sh
