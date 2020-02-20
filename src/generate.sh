#!/bin/sh

################################################################################
# This file is part of the "ssc-generator" project.
#
# Copyright (C) 2020 - Gamaliel SICK, IDEACLOUD.
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
################################################################################

set -e

PASSWORD=${PASSWORD:=sscpwd}
DEST_DIR=${DEST_DIR:=cert}
DOMAIN=${DOMAIN:=custom.foo}
ROOTCA_NAME=${ROOTCA_NAME:=rootCA}
SUBJ="/C=FR/ST=Paris/L=Paris/O=Global Security/OU=IT Department/CN=${DOMAIN}"
ROOTCA_FULL_PATH="${DEST_DIR}/${ROOTCA_NAME}"
CERTIF_BASE="${DEST_DIR}/${DOMAIN}"

if [ ! -d ${DEST_DIR} ] ; then
    mkdir -p ${DEST_DIR}
fi

if [ ! -f $CERTIF_BASE.chained.crt ] ; then
    echo "Generate ${ROOTCA_NAME}"
    openssl genrsa -des3 -passout pass:$PASSWORD -out $ROOTCA_FULL_PATH.key 4096
    if [ ! -f $ROOTCA_FULL_PATH.key ] ;
    then
        exit 1
    fi
    echo "Self sign the root certificate"
    openssl req -x509 -new -passin pass:$PASSWORD -nodes -key $ROOTCA_FULL_PATH.key -sha256 -days 1024 -out $ROOTCA_FULL_PATH.crt -subj "${SUBJ}"
    echo "Generate certificate key"
    openssl genrsa -out $CERTIF_BASE.key 2048
    echo "Generate certificate request"
    openssl req -new -key $CERTIF_BASE.key -out $CERTIF_BASE.csr -subj "${SUBJ}"
    echo "Generate certificate using certificate request"
    openssl x509 -req -passin pass:$PASSWORD -in $CERTIF_BASE.csr -CA $ROOTCA_FULL_PATH.crt -CAkey $ROOTCA_FULL_PATH.key -CAcreateserial -out $CERTIF_BASE.crt -sha256 -days 500
    echo "Remove passphrase"
    openssl rsa -in $CERTIF_BASE.key -out $CERTIF_BASE.key
    echo "${YELLOW}Check the certificate and matches"
    md5crt=$(openssl x509 -noout -modulus -in $CERTIF_BASE.crt | openssl md5 | awk '{print $2}')
    md5key=$(openssl rsa -modulus -noout -in $CERTIF_BASE.key | openssl md5 | awk '{print $2}')
    if [ $md5crt != $md5key ];
    then
        echo "Key and certificate does not match !!!!" 1>&2
        exit 1
    fi
    echo "Key and certificate matches correctly" 1>&2
    echo "Generate Diffie-Hellman (dh) for better security"
    openssl dhparam -out $DEST_DIR/dhparam.pem 2048
    echo "Generate chained certificate"
    touch $CERTIF_BASE.chained.crt
    cat $CERTIF_BASE.crt >> $CERTIF_BASE.chained.crt
    cat $ROOTCA_FULL_PATH.crt >> $CERTIF_BASE.chained.crt
    if [ ! -z "${USERGROUP}" ] ; then
    chown ${USERID}:${USERGROUP} ${DEST_DIR}/*
    echo "Set permission on certificates files"
    fi
fi
echo "Certificate generation done !"
