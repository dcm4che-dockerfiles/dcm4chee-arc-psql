#!/usr/bin/env bash

sed -e "s%dc=dcm4che,dc=org%${LDAP_BASE_DN}%" \
    -e "s%ldap://ldap:389%ldap://${LDAP_HOST}:${LDAP_PORT}%" \
    -e "s%\"bindCredential\" : \[ \"secret\"%\"bindCredential\" : \[ \"${LDAP_ROOTPASS}\"%" \
    -e "s%http://kibana:8080%${ARR_PROXY_URL}%" \
    -i $JBOSS_HOME/standalone/configuration/dcm4che-realm.json
