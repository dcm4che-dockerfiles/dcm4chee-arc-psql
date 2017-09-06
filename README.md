# Supported tags and respective `Dockerfile` links

- [`5.10.5` (*5.10.5/Dockerfile*)](https://github.com/dcm4che-dockerfiles/dcm4chee-arc-psql/blob/5.10.5/Dockerfile)
- [`5.10.5-secure-ui` (*5.10.5-secure-ui/Dockerfile*)](https://github.com/dcm4che-dockerfiles/dcm4chee-arc-psql/blob/5.10.5-secure-ui/Dockerfile)
- [`5.10.5-logstash` (*5.10.5-logstash/Dockerfile*)](https://github.com/dcm4che-dockerfiles/dcm4chee-arc-psql/blob/5.10.5-logstash/Dockerfile)
- [`5.10.5-logstash-secure-ui` (*5.10.5-logstash-secure-ui/Dockerfile*)](https://github.com/dcm4che-dockerfiles/dcm4chee-arc-psql/blob/5.10.5-logstash-secure-ui/Dockerfile)

# How to use this image

See [Running on Docker](https://github.com/dcm4che/dcm4chee-arc-light/wiki/Running-on-Docker) at the
[dcm4che Archive 5 Wiki](https://github.com/dcm4che/dcm4chee-arc-light/wiki).

#### Environment Variables 

Below explained environment variables can be set as per one's application to override the default values if need be.
An example of how one can set an env variable in `docker run` command is shown below :

    -e ARCHIVE_DEVICE_NAME=my-dcm4chee-arc

_**Note**_ : If default values of any environment variables were overridden in startup of `slapd` or `postgres` containers, 
then ensure that the same values are also used for overriding the defaults during startup of archive container. 

##### `LDAP_BASE_DN`

This environment variable sets the base domain name for LDAP. Default value is _**dc=dcm4che,dc=org**_.

### `LDAP_ORGANISATION`

This environment variable sets the organisation name for LDAP. Default value is "dcm4che.org".

##### `LDAP_ROOTPASS`

This environment variable sets the root password for LDAP. Default value is _**secret**_. 

##### `LDAP_CONFIGPASS`

This environment variable sets the password for users who wish to change the schema configuration in LDAP. 
Default value is _**secret**_. 

##### `ARCHIVE_DEVICE_NAME`

This is the name of archive device which can be set per one's application. Default value is _**dcm4chee-arc**_. 

##### `POSTGRES_DB`

This environment variable defines the name for the default database that is created when the postgres image was started.
Default value is _**pacsdb**_. 

##### `POSTGRES_USER`

This environment variable used in conjunction with `POSTGRES_PASSWORD` is the user with superuser power and its password. 
Default value is _**pacs**_. 

##### `POSTGRES_PASSWORD`

This environment variable is the superuser password for PostgreSQL. Default value is _**pacs**_. 

##### `JAVA_OPTS`

This environment variable is used to set the JAVA_OPTS during archive startup. Default value is 
_**"-Xms64m -Xmx512m -XX:MetaspaceSize=96M -XX:MaxMetaspaceSize=256m -Djava.net.preferIPv4Stack=true -Djboss.modules.system.pkgs=org.jboss.byteman -Djava.awt.headless=true"**_

##### `WILDFLY_CHOWN`

This environment variable is used to set the ownership to the storage directory. Default value is 
_**"/opt/wildfly/standalone /storage"**_
