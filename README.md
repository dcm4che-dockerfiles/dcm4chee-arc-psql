# Supported tags and respective `Dockerfile` links

- [`5.34.1` (*5.34.1/Dockerfile*)](https://github.com/dcm4che-dockerfiles/dcm4chee-arc-psql/blob/5.34.1/Dockerfile)
- [`5.34.1-secure` (*5.34.1-secure/Dockerfile*)](https://github.com/dcm4che-dockerfiles/dcm4chee-arc-psql/blob/5.34.1-secure/Dockerfile)
- [`5.34.1-secure-ui` (*5.34.1-secure-ui/Dockerfile*)](https://github.com/dcm4che-dockerfiles/dcm4chee-arc-psql/blob/5.34.1-secure-ui/Dockerfile)

## How to use this image

See [Running on Docker](https://github.com/dcm4che/dcm4chee-arc-light/wiki/Running-on-Docker) at the
[dcm4che Archive 5 Wiki](https://github.com/dcm4che/dcm4chee-arc-light/wiki).

## Environment Variables

Below explained environment variables can be set as per one's application to override the default values if need be.
An example of how one can set an env variable in `docker run` command is shown below :

    -e ARCHIVE_DEVICE_NAME=my-dcm4chee-arc

_**Note**_ : If default values of any environment variables were overridden in startup of `slapd` or `postgres` containers, 
then ensure that the same values are also used for overriding the defaults during startup of archive container. 

#### `LDAP_URL`

URL for accessing LDAP (optional, default is `ldap://ldap:389`).

#### `LDAP_BASE_DN`

Base domain name for LDAP (optional, default is `dc=dcm4che,dc=org`).

#### `LDAP_ROOTPASS`

Password to use to authenticate to LDAP (optional, default is `secret`).

#### `LDAP_ROOTPASS_FILE`

Password to use to authenticate to LDAP via file input (alternative to `LDAP_ROOTPASS`).

#### `LDAP_DISABLE_HOSTNAME_VERIFICATION`

Indicates to disable the verification of the hostname of the certificate of the LDAP server,
if using TLS (`LDAP_URL=ldaps://<host>:<port>`) (optional, default is `true`).

#### `ARCHIVE_DEVICE_NAME`

Device name to lookup in LDAP for Audit Logging configuration (optional, default is `dcm4chee-arc`).

#### `DCM4CHEE_ARC_URLS`

Space separated list of URL(s) of Archive RESTful services deployed in this and other Archive docker container(s).
E.g.: `http://dcm4chee-arc-1:8080/dcm4chee-arc http://dcm4chee-arc-2:8080/dcm4chee-arc` (optional, default is `/dcm4chee-arc`).

#### `POSTGRES_HOST`

Hostname/IP-Address of the PostgreSQL host. Required for using external PostgreSQL database to persist data.
If absent, embedded Java-based relational database H2 will be used to persist data (optional, default is `db`).

#### `POSTGRES_PORT`
             
Port of the PostgreSQL host (optional, default is `5432`)

#### `POSTGRES_DB`
                 
Name of the database to use (optional, default is `pacsdb`).

#### `POSTGRES_USER`
             
User to authenticate to PostgreSQL (optional, default is `pacs`).

#### `POSTGRES_USER_FILE`
                  
User to authenticate to PostgreSQL via file input (alternative to `POSTGRES_USER`).

#### `POSTGRES_PASSWORD`

User's password to use to authenticate to PostgreSQL (optional, default is `pacs`).

#### `POSTGRES_PASSWORD_FILE`
                      
User's password to use to authenticate to PostgreSQL via file input (alternative to `DB_PASSWORD`).

#### `POSTGRES_JDBC_PARAMS`
                      
Optional JDBC [Connection Parameters](https://jdbc.postgresql.org/documentation/head/connect.html) (e.g.: `connectTimeout=30`).

#### `JBOSS_JAVA_SIZING`

This environment variable is used to set the initial and maximal Java heap size,
the size of the allocated class metadata space that will trigger a garbage collection the first time it is exceeded and
the maximum amount of native memory that can be allocated for class metadata (optional, default is 
`"-Xms64m -Xmx512m -XX:MetaspaceSize=96M -XX:MaxMetaspaceSize=256m"`).

#### `JAVA_OPTS`

This environment variable is used to set the JAVA_OPTS during archive startup (optional, default is 
`"$JBOSS_JAVA_SIZING -Djava.net.preferIPv4Stack=true -Djboss.modules.system.pkgs=org.jboss.byteman -Djava.awt.headless=true"`).

#### `REVERSE_DNS`

Specifies if reverse DNS lookup is enabled for incoming DICOM and HL7 connections (optional, default is `true`).

#### `WILDFLY_STANDALONE`

Specifies subdirectories of - typically host mounted - `/opt/wildfly/standalone/` which files and subdirectories get
updated by newer versions from corresponding subdirectories of `/docker-entrypoint.d/` provided by the image on each
container start. (optional, default is `configuration deployments`).

#### `WILDFLY_CONFIGURATION_VERSION`

If file `/opt/wildfly/standalone/configuration/VERSION` does not contain `$WILDFLY_CONFIGURATION_VERSION`,
XML configuration files in `/opt/wildfly/standalone/configuration` will be replaced by versions from
`/docker-entrypoint.d/configuration` provided by the image on first container start, even if the modification time of
existing files is newer than the files from the docker image, backing up existing files as `XY.xml~`.
File `/opt/wildfly/standalone/configuration/VERSION` will be created/updated to contain `$WILDFLY_CONFIGURATION_VERSION`
to ensure that the configuration files does not get overwritten on next container start, as long
`WILDFLY_CONFIGURATION_VERSION` is not set to a different value.

By default, it is set to `$ARCHIVE_ARC_VERSION`, which ensures that the configuration files are replaced if the
archive version provided by the image changes.

#### `WILDFLY_STANDALONE_PRESERVE`

Specifies a subset of subdirectories of `/opt/wildfly/standalone/` specified by [WILDFLY_STANDALONE](#wildfly_standalone),
which files shall **not** be overwritten by newer versions from corresponding subdirectories of
`/docker-entrypoint.d/` provided by the image on each container start.

#### `WILDFLY_CHOWN`

Force the container to mutate the ownership of specified space separated list of directories recursively to uid:gid `1023:1023`,
which provides the required read/write access to the Wildfly process. Enables to let the container create the storage directory
specified by LDAP docker container environment variable [STORAGE_DIR](https://github.com/dcm4che-dockerfiles/slapd-dcm4chee#storage_dir)
on first start up. Directories and files below `/opt/wildfly` - and so default storage directory `/opt/wildfly/standalone/data/fs1` -
get owned by the user and group of the Wildfly process by default, without the need to refer them by that environment variable.

#### `WILDFLY_WAIT_FOR`

Indicates to delay the start of the archive until specified TCP ports become accessible. Format: `<host>:<port> ...`, e.g.: `ldap:389 db:5432`.

#### `WILDFLY_START_DELAY`

Indicates to delay the start of the archive for a specified amount of time in seconds after TCP ports specified by `WILDFLY_WAIT_FOR` become accessible.
By default, the archive is started as soon all TCP ports specified by `WILDFLY_WAIT_FOR` become accessible without further delay.

#### `WILDFLY_SERVER_LOG_SUFFIX`

Suffix string for `/opt/wildfly/standalone/log/server.log*` files. The period of the rotation is automatically calculated
based on the suffix (optional, default is `.yyyy-MM-dd`).

#### `WILDFLY_AUDIT_LOG_SUFFIX`

Suffix string for `/opt/wildfly/standalone/log/audit.log*` and `/opt/wildfly/standalone/log/audit-log.log*` files.
The period of the rotation is automatically calculated based on the suffix (optional, default is `.yyyy-MM-dd`).

#### `WILDFLY_SERVER_LOG_PATTERN`

Pattern for formatter `PATTERN` for system log messages to `/opt/wildfly/standalone/log/server.log*` files.
(optional, default is `%d{yyyy-MM-dd HH:mm:ss,SSS} %-5p [%c] (%t) %s%e%n`).

#### `HTTP_MAX_POST_SIZE`

The maximum size of a HTTP POST request that will be accepted, in bytes. (optional, default is `10000000000`).

#### `HTTP_PROXY_ADDRESS_FORWARDING`

If this is enabled then the X-Forwarded-For and X-Forwarded-Proto headers will be used to determine the peer address.
This allows applications that are behind a proxy to see the real address of the client, rather than the address
of the proxy.  (optional, default is `false`).

#### `HTTP_PORT`

HTTP port of Wildfly (optional, default is `8080`).

#### `HTTPS_PORT`

HTTPS port of Wildfly (optional, default is `8443`).

#### `REDIRECT_HTTPS_PORT`

HTTPS port to redirect requests that require security too. (optional, default is `8443`).
Have to be set different to `HTTPS_PORT`, if running behind a HTTPS/SSL reverse proxy listing on a different port.

#### `MANAGEMENT_HTTP_PORT`

HTTP port of Wildfly Administration Console (optional, default is `9990`).

#### `MANAGEMENT_HTTPS_PORT`

HTTPS port of Wildfly Administration Console (optional, default is `9993`).

#### `UI_MANAGEMENT_URL`

HTTPS URL used by the browser based Archive UI to access the Wildfly Administration Console.
Only necessary, if running behind a HTTPS/SSL reverse proxy listing on a different port from `MANAGEMENT_HTTPS_PORT` or 
using different virtual hosts for forwarding HTTP requests to the Wildfly Administration Console than to regular Wildfly
HTTP/HTTPS interfaces.

#### `WILDFLY_DEPLOY_UI`

Controls deployment of the Archive UI. Enumerated values:
- `true` ; deploys the Archive UI additionally to the Archive backend (= default)
- `false` ; deploys the Archive backend without the Archive UI
- `only` ; deploys only the Archive UI without the Archive backend (requires `DCM4CHEE_ARC_URLS`](#dcm4chee_arc_urls))

#### `WILDFLY_ADMIN_OIDC` (Only effective by archive versions secured by Keycloak)

Protect Wildfly Adminstration Console with Keycloak (optional, default is `true`).

#### `WILDFLY_ADMIN_USER` (Ignored by archive versions secured by Keycloak and `WILDFLY_ADMIN_OIDC=true`)

By default there is no admin user created so you won't be able to login to the Wildfly Administration Console.
User to authenticate to the Wildfly Administration Console.
(At archive versions secured by Keycloak and `WILDFLY_ADMIN_OIDC=true`, any user with assigned role `ADMINISTRATOR`
is authorized to access the Wildfly Administration Console.)

#### `WILDFLY_ADMIN_USER_FILE` (Ignored by archive versions secured by Keycloak and `WILDFLY_ADMIN_OIDC=true`)

User to authenticate to the Wildfly Administration Console via file input (alternative to WILDFLY_ADMIN_USER).

#### `WILDFLY_ADMIN_PASSWORD` (Ignored by archive versions secured by Keycloak and `WILDFLY_ADMIN_OIDC=true`)

User's password to use to authenticate to the Wildfly Administration Console.

#### `WILDFLY_ADMIN_PASSWORD_FILE` (Ignored by archive versions secured by Keycloak and `WILDFLY_ADMIN_OIDC=true`)

User's password to use to authenticate to the Wildfly Administration Console via file input (alternative to WILDFLY_ADMIN_PASSWORD).

#### `AUTH_USER_ROLE`

User role required to access the UI and RESTful services of the Archive (optional, default is `auth`).

#### `SUPER_USER_ROLE`

User role to identify super users, which have unrestricted access to all UI functions of the Archive, bypassing the
verification of user permissions (optional, default is `root`).

#### `PROXY_USER_ROLE`

User role required to access HTTP services over a proxy. (optional, default is `user`).

#### `KEYSTORE`

Path to keystore file with private key and certificate for HTTPS (optional, default is
`/opt/wildfly/standalone/configuration/keystore/key.p12`, with sample key + certificate:
```
Owner: CN=dcm4che, O=dcm4che.org, C=AT
Issuer: OU=Gazelle, CN=IHE Europe CA, O=IHE Europe, C=FR
Serial number: 626
Valid from: Wed Sep 18 16:54:44 CEST 2024 until: Mon Sep 18 16:54:44 CEST 2034
Certificate fingerprints:
	 SHA1: C6:E1:8E:52:3D:BB:32:9B:AA:7E:6A:DF:54:5E:15:99:A9:1B:A8:43
	 SHA256: 0C:0E:09:6A:D8:6B:9F:8C:E2:9C:60:C3:4C:E8:29:CB:64:67:08:7F:41:5B:79:12:AA:A2:45:18:CE:82:B6:96
Signature algorithm name: SHA512withRSA
Subject Public Key Algorithm: 2048-bit RSA key
```
provided by the docker image only for testing purpose).

#### `KEYSTORE_PASSWORD`

Password used to protect the integrity of the keystore specified by `KEYSTORE` (optional, default is `secret`).

#### `KEYSTORE_PASSWORD_FILE`

Password used to protect the integrity of the keystore specified by `KEYSTORE` via file input
(alternative to `KEYSTORE_PASSWORD`).

#### `KEY_PASSWORD`

Password used to protect the private key in the keystore specified by `KEYSTORE`
(optional, default is value of `KEYSTORE_PASSWORD`).

#### `KEY_PASSWORD_FILE`

Password used to protect the private key in the keystore specified by `KEYSTORE` via file input
(alternative to `KEY_PASSWORD`).

#### `KEYSTORE_TYPE`

Type (`JKS` or `PKCS12`) of the keystore specified by `KEYSTORE` (optional, default is `PKCS12`).

#### `TRUSTSTORE`

Path to keystore file with trusted certificates for TLS (optional, default is the default Java truststore
`$JAVA_HOME/lib/security/cacerts`). s.o. [EXTRA_CACERTS](#extra_cacerts).

#### `TRUSTSTORE_PASSWORD`

Password used to protect the integrity of the keystore specified by `TRUSTSTORE` (optional, default is `changeit`).

#### `TRUSTSTORE_PASSWORD_FILE`

Password used to protect the integrity of the keystore specified by `TRUSTSTORE` via file input
(alternative to `TRUSTSTORE_PASSWORD`).

#### `TRUSTSTORE_TYPE`

Type (`JKS` or `PKCS12`) of the keystore specified by `TRUSTSTORE` (optional, default is `JKS`).

#### `EXTRA_CACERTS`

Path to keystore file with CA certificates imported to default Java truststore (optional, default is
`/opt/wildfly/standalone/configuration/keystore/cacerts.p12`, with sample CA certificate:
```
Owner: OU=Gazelle, CN=IHE Europe CA, O=IHE Europe, C=FR
Issuer: OU=Gazelle, CN=IHE Europe CA, O=IHE Europe, C=FR
Serial number: 1
Valid from: Tue Nov 27 11:21:33 CET 2018 until: Mon Nov 27 11:21:33 CET 2028
Certificate fingerprints:
	 SHA1: 95:B3:01:BD:8B:97:46:D3:17:C4:E6:96:42:C9:84:FC:17:8D:E9:6F
	 SHA256: 21:EB:CA:86:4A:08:E9:A2:D2:1F:6E:84:37:8D:60:BB:14:92:4D:1B:B0:DD:B0:DC:75:03:0C:2E:F3:B2:6E:DD
Signature algorithm name: SHA512withRSA
Subject Public Key Algorithm: 2048-bit RSA key
```
provided by the docker image only for testing purpose).

#### `EXTRA_CACERTS_PASSWORD`

Password used to protect the integrity of the keystore specified by `EXTRA_CACERTS` (optional, default is `secret`).

#### `EXTRA_CACERTS_PASSWORD_FILE`

Password used to protect the integrity of the keystore specified by `EXTRA_CACERTS` via file input
(alternative to `EXTRA_CACERTS_PASSWORD`).

#### `NEED_CLIENT_AUTH`

Enables mutual TLS authentication for incoming HTTP connections: request HTTPS clients to provide a certificate and
reject the connection if that is not signed by a trusted certificate (see [`TRUSTSTORE`](#truststore))
(optional, default is `false`). environment

#### `TLS_PROTOCOLS`

Comma separated list of enabled TLS protocols (`SSLv2`, `SSLv3`, `TLSv1`, `TLSv1.1`, `TLSv1.2`, `TLSv1.3`)
(optional, default is `TLSv1.2`). 

#### `CIPHER_SUITE_FILTER`

The filter to apply to specify the enabled cipher suites for TLSv1.2 and below. See
[javadoc](https://wildfly-security.github.io/wildfly-elytron/documentation/api/upstream/org/wildfly/security/ssl/CipherSuiteSelector.html#fromString(java.lang.String))
for possible values. (optional, default is `DEFAULT`).

##### `GZIP_FILTER_PREDICATE`

Predicate to enable gzip compression of HTTP responses. See
[Textual Representation of Predicates](https://undertow.io/undertow-docs/undertow-docs-2.1.0/index.html#textual-representation-of-predicates)
for possible formats. (optional, default is `method(GET) and path-suffix(studies,series,instances,metadata)`.

##### `AUTH_SERVER_URL`

Backend Endpoint URL of the Keycloak server for direct communication between the archive application and Keycloak for
authenticating client requests.
Default value is `https://keycloak:8443`.

##### `UI_AUTH_SERVER_URL`

Frontend Endpoint URL of the Keycloak server used by the browser based Archive UI to access Keycloak. If there is a
reverse proxy in front of Keycloak, the URL has to reflect hostname and port of the reverse proxy.
Default value is `${AUTH_SERVER_URL}`.

##### `REALM_NAME`

Name of the realm configured in Keycloak for securing the UI and RESTful services of the archive,
and the Wildfly Administration Console and Management API (optional, default is `dcm4che`). 

##### `SSL_REQUIRED`

Defining the SSL/HTTPS requirements for interacting with the Keycloak server:
- `none` - HTTPS is not required for any client IP address
- `external` - private IP addresses can access without HTTPS
- `all` - HTTPS is required for all IP addresses

(optional, default is `external`).

#### `ALLOW_ANY_HOSTNAME`

If the Keycloak server requires HTTPS and this config option is set to `true` the Keycloak server’s certificate is 
validated via the truststore, but host name validation is not done (optional, default value set is `true`).

#### `DISABLE_TRUST_MANAGER`

If the Keycloak server requires HTTPS and this config option is set to `true` the Keycloak server’s certificate is 
is **not** validated via the truststore (optional, default value set is `false`).

##### `UI_CLIENT_ID`

Keycloak client ID for securing the UI of the archive (optional, default is `dcm4chee-arc-ui`).

#### `RS_CLIENT_ID`

Keycloak client ID for securing RESTful services of the archive (optional, default is `dcm4chee-arc-rs`).

#### `WILDFLY_CONSOLE`

Keycloak client ID for [securing the Wildfly Administration Console](https://docs.jboss.org/author/display/WFLY/Protecting+Wildfly+Adminstration+Console+With+Keycloak)
(optional, default is `wildfly-console`).

#### `WILDFLY_MANAGEMENT`

Keycloak client ID for [securing the Wildfly Management API](https://docs.jboss.org/author/display/WFLY/Protecting+Wildfly+Adminstration+Console+With+Keycloak).
(optional, default is `wildfly-management`).

#### `WILDFLY_EXECUTER_MAX_THREADS`

Maximum threads allowed for the managed-executor-service in the Wildfly configuration
(optional, default is `100`).

#### `WILDFLY_PACSDS_USE_CCM`

Enable the use of a cached connection manager
(optional, default is `true`).

#### `WILDFLY_PACSDS_MAX_POOL_SIZE`

Maximum pool size allowed for the PacsDS datasource in the Wildfly configuration
(optional, default is `50`).

#### `WILDFLY_DISABLE_CACHING_FOR_SECURED_PAGES`

Controls if Wildfly Undertow servlet container should set headers to disable caching for secured pages
(optional, default is `false`).

#### `WILDFLY_RESOLVE_PEER_ADDRESS`

Enables host DNS lookup of peer address by Wildfly Undertow servlet container
(optional, default is `false`).

### [Logstash/GELF Logger](https://logging.paluch.biz/) configuration:

#### `LOGSTASH_HOST`

Hostname/IP-Address of the Logstash host. Required for emitting system logs to [Logstash](https://www.elastic.co/products/logstash).

#### `GELF_FACILITY`

Name of the Facility (optional, default is `wildfly`).

#### `GELF_LEVEL`

Log-Level threshold (optional, default is `WARN`).

#### `GELF_EXTRACT_STACK_TRACE`

Indicates if the Stack-Trace shall be sent in the StackTrace field (optional, default is `true`).

#### `GELF_FILTER_STACK_TRACE`

Indicates if Stack-Trace filtering shall be performed (optional, default is `true`).

## Deploy additional application(s)

You may extend the image by creating a new one and place your application(s) inside the
`/docker-entrypoint.d/deployments/` directory with the `COPY` command. E.g.:

```console
$ ls
Dockerfile  weasis-pacs-connector.war
```
```console
$ cat Dockerfile
FROM dcm4che/dcm4chee-arc-psql:5.34.1
COPY weasis-pacs-connector.war /docker-entrypoint.d/deployments
```
```console
$ docker build -t dcm4chee-arc-psql-with-weasis-pacs-connector:5.34.1 .
Sending build context to Docker daemon  1.924MB
Step 1/2 : FROM dcm4che/dcm4chee-arc-psql:5.34.1
5.34.1: Pulling from dcm4che/dcm4chee-arc-psql
c7b7d16361e0: Already exists
b7a128769df1: Already exists
1128949d0793: Already exists
667692510b70: Already exists
5352881f31d4: Already exists
9c5c547fc9af: Already exists
1425a6f5654d: Already exists
5686d3c45e41: Already exists
d26ca0854059: Already exists
b04b5d1d48ca: Already exists
73f6e4c54635: Already exists
495a8a1a3634: Pull complete
01e5664d91d6: Pull complete
22267eaaa65e: Pull complete
Digest: sha256:efd76ca282504bc3e7284cc544434dd769a84b45af5f96ff84ed462a6425780d
Status: Downloaded newer image for dcm4che/dcm4chee-arc-psql:5.34.1
 ---> c84231dce4d2
Step 2/2 : COPY weasis-pacs-connector.war /docker-entrypoint.d/deployments
 ---> b0f94489c0cb
Successfully built b0f94489c0cb
Successfully tagged dcm4chee-arc-psql-with-weasis-pacs-connector:5.34.1
```
