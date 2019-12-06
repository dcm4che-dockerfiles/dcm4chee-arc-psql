#!/bin/bash

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}

file_env 'LDAP_ROOTPASS' 'secret'
file_env 'POSTGRES_USER' 'pacs'
file_env 'POSTGRES_PASSWORD' 'pacs'
file_env 'KEYSTORE_PASSWORD' 'secret'
file_env 'KEY_PASSWORD' "${KEYSTORE_PASSWORD}"
file_env 'TRUSTSTORE_PASSWORD' 'secret'
file_env 'WILDFLY_ADMIN_USER'
file_env 'WILDFLY_ADMIN_PASSWORD'

# Append '?' in the beginning of the string if POSTGRES_JDBC_PARAMS value isn't empty
POSTGRES_JDBC_PARAMS=$(echo ${POSTGRES_JDBC_PARAMS} | sed '/^$/! s/^/?/')

if [ "$WILDFLY_ADMIN_OIDC" != 'false' ]; then
	OIDC="-oidc"
fi

if [ -n "$LOGSTASH_HOST" ]; then
	LOGSTASH="-logstash"
fi

SYS_PROPS="-c dcm4chee-arc${OIDC}${LOGSTASH}.xml"
SYS_PROPS+=" -Djboss.management.http.port=${MANAGEMENT_HTTP_PORT:-9990}"
SYS_PROPS+=" -Djboss.management.https.port=${MANAGEMENT_HTTPS_PORT:-9993}"
SYS_PROPS+=" -Djboss.http.port=${HTTP_PORT:-8080}"
SYS_PROPS+=" -Djboss.https.port=${HTTPS_PORT:-8443}"
