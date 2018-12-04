# Supported tags and respective `Dockerfile` links

- [`5.15.1` (*5.15.1/Dockerfile*)](https://github.com/dcm4che-dockerfiles/dcm4chee-arc-psql/blob/5.15.1/Dockerfile)
- [`5.15.1-secure` (*5.15.1-secure/Dockerfile*)](https://github.com/dcm4che-dockerfiles/dcm4chee-arc-psql/blob/5.15.1-secure/Dockerfile)
- [`5.15.1-secure-ui` (*5.15.1-secure-ui/Dockerfile*)](https://github.com/dcm4che-dockerfiles/dcm4chee-arc-psql/blob/5.15.1-secure-ui/Dockerfile)
- [`5.15.1-logstash` (*5.15.1-logstash/Dockerfile*)](https://github.com/dcm4che-dockerfiles/dcm4chee-arc-psql/blob/5.15.1-logstash/Dockerfile)
- [`5.15.1-logstash-secure` (*5.15.1-logstash-secure/Dockerfile*)](https://github.com/dcm4che-dockerfiles/dcm4chee-arc-psql/blob/5.15.1-logstash-secure/Dockerfile)
- [`5.15.1-logstash-secure-ui` (*5.15.1-logstash-secure-ui/Dockerfile*)](https://github.com/dcm4che-dockerfiles/dcm4chee-arc-psql/blob/5.15.1-logstash-secure-ui/Dockerfile)

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

This environment variable sets the URL for accessing LDAP. Default value is `ldap://ldap:389`.

#### `LDAP_BASE_DN`

This environment variable sets the base domain name for LDAP. Default value is `dc=dcm4che,dc=org`.

#### `LDAP_ROOTPASS`

This environment variable sets the password for LDAP.
Only effective if the file specified by `LDAP_ROOTPASS_FILE` does not exist. Default value is `secret`.

#### `LDAP_ROOTPASS_FILE`

Path to file containing the password for LDAP.
If the file does not exist, it will be created containing the password specified by `LDAP_ROOTPASS`. 
Default value is `/tmp/ldap_rootpass`.

#### `POSTGRES_HOST`

This environment variable sets the host name for POSTGRES. Default value is `db`.

#### `POSTGRES_PORT`

This environment variable sets the port for POSTGRES. Default value is `5432`.

#### `POSTGRES_DB`

This environment variable defines the name for the default database. Default value is `pacsdb`. 

#### `POSTGRES_USER`

This environment variable used in conjunction with POSTGRES_PASSWORD is the user with superuser power and its password. 
Default value is `pacs`. 

#### `POSTGRES_PASSWORD`

This environment variable is the password for PostgreSQL. 
Only effective if the file specified by `POSTGRES_PASSWORD_FILE` does not exist. Default value is `pacs`.

#### `POSTGRES_PASSWORD_FILE`

Path to file containing the password for PostgreSQL.
If the file does not exist, it will be created containing the password specified by `POSTGRES_PASSWORD`. 
Default value is `/tmp/postgres_password`.

#### `ARCHIVE_DEVICE_NAME`

This is the name of archive device which can be set per one's application. Default value is `dcm4chee-arc`. 

#### `JAVA_OPTS`

This environment variable is used to set the JAVA_OPTS during archive startup. Default value is 
`"-Xms64m -Xmx512m -XX:MetaspaceSize=96M -XX:MaxMetaspaceSize=256m -Djava.net.preferIPv4Stack=true -Djboss.modules.system.pkgs=org.jboss.byteman -Djava.awt.headless=true"`

#### `REVERSE_DNS`

Specifies if reverse DNS lookup is enabled for incoming DICOM and HL7 connections. Default value is `true`.

#### `WILDFLY_CHOWN`

This environment variable is used to set the ownership to the storage directory. Default value is 
`"/opt/wildfly/standalone /storage"`

#### `HTTP_PORT`

This environment variable sets the Http port of Wildfly. Default value is `8080`.

#### `HTTPS_PORT`

This environment variable sets the Https port of Wildfly. Default value is `8443`.

#### `MANAGEMENT_HTTP_PORT`

This environment variable sets the Management Http port of Wildfly. Default value is `9990`.

#### `WILDFLY_ADMIN_USER`

This environment variable sets the admin user name for Wildfly. Default value is `admin`.

#### `SUPER_USER_ROLE`

This environment variable sets the user role to identify super users, which have unrestricted access to all UI functions,
bypassing the verification of user permissions. Default value is `admin`.

#### `KEYSTORE`

This environment variable sets the keystore used in ssl server identities in Wildfly configuration. Default value is
`/opt/wildfly/standalone/configuration/dcm4chee-arc/key.jks`.

#### `KEYSTORE_PASSWORD`

This environment variables sets the password of the keystore used in ssl server identities in Wildfly configuration.
Only effective if the file specified by `KEYSTORE_PASSWORD_FILE` does not exist. Default value is `secret`.

#### `KEYSTORE_PASSWORD_FILE`

Path to file containing the password of the keystore used in ssl server identities in Wildfly configuration.
If the file does not exist, it will be created containing the password specified by `KEYSTORE_PASSWORD`. 
Default value is `/tmp/keystore_password`.

#### `KEY_PASSWORD`

This environment variables sets the password of the key used in ssl server identities in Wildfly configuration.
Only effective if the file specified by `KEY_PASSWORD_FILE` does not exist. Default value is `secret`.

#### `KEY_PASSWORD_FILE`

Path to file containing the password of the key used in ssl server identities in Wildfly configuration.
If the file does not exist, it will be created containing the password specified by `KEY_PASSWORD`. 
Default value is `/tmp/key_password`.

#### `KEYSTORE_TYPE`

This environment variable sets the type of keystore that is used above. Default value is `JKS`.

#### `TRUSTSTORE`

This environment variable sets the truststore which will be used to verify Keycloak's certificate in Https communication.
Default value is `/opt/wildfly/standalone/configuration/dcm4chee-arc/cacerts.jks`.

#### `TRUSTSTORE_PASSWORD`

This environment variable sets the password of the above truststore.
Only effective if the file specified by `TRUSTSTORE_PASSWORD_FILE` does not exist. Default value is `secret`.

#### `TRUSSTORE_PASSWORD_FILE`

Path to file containing the password of the above truststore.
If the file does not exist, it will be created containing the password specified by `TRUSTSTORE_PASSWORD`. 
Default value is `/tmp/truststore_password`.

#### `SSL_REQUIRED`

This environment variable defines the SSL/HTTPS requirements for interacting with the realm. Default value is `external`.
Values which are accepted are : `external`, `none` or `all`.

##### `REALM_NAME`

This is the name of the realm configured in Keycloak for securing archive UI and RESTful services. Default value is `dcm4che`.

#### `ALLOW_ANY_HOSTNAME`

If the Keycloak server requires HTTPS and this config option is set to true the Keycloak server’s certificate is 
validated via the truststore, but host name validation is not done. Default value set is `true`.

##### `AUTH_SERVER_URL`

This environment variable is the auth-server-url of Keycloak used for authenticating the client requests. 
Default value is `http://keycloak:8080/auth`.

#### `UI_CLIENT_ID`

This environment variable sets the client ID for the UI client. This value is used in creation of client for securing 
archive's UI. Default value set is `dcm4chee-arc-ui`.

#### `RS_CLIENT_ID`

This environment variable sets the client ID for the RESTful client. This value is used in creation of client 
for securing archive's RESTful services. Default value set is `dcm4chee-arc-rs`.

#### `WILDFLY_EXECUTER_MAX_THREADS`

This environment variable sets the maximum threads allowed for the managed-executor-service in the Wildfly configuration. 
Default value is `100`.

#### `WILDFLY_PACSDS_MAX_POOL_SIZE`

This environment variable sets the maximum pool size allowed for the PacsDS datasource in the Wildfly configuration.
Default value is `50`.

#### `WILDFLY_MDB_STRICT_MAX_POOL_SIZE`

Configured maximum number of message driven bean instances that the pool can hold at a given point in time.
Default value is `32`.

#### `WILDFLY_DISABLE_CACHING_FOR_SECURED_PAGES`

Indicates if Wildfly Undertow servlet container should set headers to disable caching for secured pages.
Default value is `false`.

#### `WILDFLY_JMS_QUEUE_STGCMTSCP_CONSUMER_COUNT`

The number of consumers consuming messages from queue `StgCmtSCP`. Limits number of concurrently processed Storage
Commitment requests. Default value is `1`.

#### `WILDFLY_JMS_QUEUE_STGCMTSCU_CONSUMER_COUNT`

The number of consumers consuming messages from queue `StgCmtSCU`. Limits number of concurrently invoked Storage
Commitment requests. Default value is `1`.

#### `WILDFLY_JMS_QUEUE_STGVERTASKS_CONSUMER_COUNT`

The number of consumers consuming messages from queue `StgVerTasks`. Limits number of concurrently invoked Storage
Verification tasks. Default value is `1`.

#### `WILDFLY_JMS_QUEUE_MPPSSCU_CONSUMER_COUNT`

The number of consumers consuming messages from queue `MPPSSCU`. Limits number of concurrently forwarded MPPS messages.
Default value is `1`.

#### `WILDFLY_JMS_QUEUE_IANSCU_CONSUMER_COUNT`

The number of consumers consuming messages from queue `IANSCU`. Limits number of concurrently sent IAN notifications.
Default value is `1`.

#### `WILDFLY_JMS_QUEUE_EXPORT1_CONSUMER_COUNT`

The number of consumers consuming messages from queue `Export1`. Limits number of concurrently processed Export Tasks
from `Export1` queue. Default value is `1`.

#### `WILDFLY_JMS_QUEUE_EXPORT2_CONSUMER_COUNT`

The number of consumers consuming messages from queue `Export2`. Limits number of concurrently processed Export Tasks
from `Export2` queue. Default value is `1`.

#### `WILDFLY_JMS_QUEUE_EXPORT3_CONSUMER_COUNT`

The number of consumers consuming messages from queue `Export3`. Limits number of concurrently processed Export Tasks
from `Export3` queue. Default value is `1`.

#### `WILDFLY_JMS_QUEUE_EXPORT4_CONSUMER_COUNT`

The number of consumers consuming messages from queue `Export4`. Limits number of concurrently processed Export Tasks
from `Export4` queue. Default value is `1`.

#### `WILDFLY_JMS_QUEUE_EXPORT5_CONSUMER_COUNT`

The number of consumers consuming messages from queue `Export5`. Limits number of concurrently processed Export Tasks
from `Export5` queue. Default value is `1`.

#### `WILDFLY_JMS_QUEUE_EXPORT6_CONSUMER_COUNT`

The number of consumers consuming messages from queue `Export6`. Limits number of concurrently processed Export Tasks
from `Export6` queue. Default value is `1`.

#### `WILDFLY_JMS_QUEUE_EXPORT7_CONSUMER_COUNT`

The number of consumers consuming messages from queue `Export7`. Limits number of concurrently processed Export Tasks
from `Export7` queue. Default value is `1`.

#### `WILDFLY_JMS_QUEUE_EXPORT8_CONSUMER_COUNT`

The number of consumers consuming messages from queue `Export8`. Limits number of concurrently processed Export Tasks
from `Export8` queue. Default value is `1`.

#### `WILDFLY_JMS_QUEUE_EXPORT9_CONSUMER_COUNT`

The number of consumers consuming messages from queue `Export9`. Limits number of concurrently processed Export Tasks
from `Export9` queue. Default value is `1`.

#### `WILDFLY_JMS_QUEUE_EXPORT10_CONSUMER_COUNT`

The number of consumers consuming messages from queue `Export10`. Limits number of concurrently processed Export Tasks
from `Export10` queue. Default value is `1`.

#### `WILDFLY_JMS_QUEUE_HL7SEND_CONSUMER_COUNT`

The number of consumers consuming messages from queue `HL7Send`. Limits number of concurrently sent HL7v2 messages.
Default value is `1`.

#### `WILDFLY_JMS_QUEUE_RSCLIENT_CONSUMER_COUNT`

The number of consumers consuming messages from queue `RSClient`. Limits number of concurrently forwarded RESTful
requests. Default value is `1`.

#### `WILDFLY_JMS_QUEUE_CMOVESCU_CONSUMER_COUNT`

The number of consumers consuming messages from queue `CMoveSCU`. Limits number of concurrently invoked retrieve
requests. Default value is `1`.

#### `WILDFLY_JMS_QUEUE_DIFFTASKS_CONSUMER_COUNT`

The number of consumers consuming messages from queue `DiffTasks`. Limits number of concurrently processed Studies
Compare Tasks. Default value is `1`.

#### `SYSLOG_HOST`

Specifies host name to which Wildfly Gelf Logger This environment variable is the host name of logstash container used
in Wildfly configuration. Default value is `logstash`.

#### `GELF_EXTRACT_STACK_TRACE`

Indicates if the Wildfly Gelf Logger sends the Stack-Trace to the StackTrace field (true/false) . Default value is `true`.

#### `GELF_FILTER_STACK_TRACE`

Indicates if the Wildfly Gelf Logger performs Stack-Trace filtering (true/false) . Default value is `true`.

#### `GELF_FACILITY`

This environment variable sets the facility name needed by GELF logging used in wildfly configuration. Default value is `dcm4chee-arc`.

#### `GELF_LEVEL`

This environment variable sets the level of GELF logging used in wildfly configuration. Default value is `WARN`.