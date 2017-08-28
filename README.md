### dcm4chee-arc-psql Docker image

This is a Dockerfile with the DICOM Archive [dcm4chee-arc-light](https://github.com/dcm4che/dcm4chee-arc-light/wiki)
for use with Postgres SQL as database. Beside Postgres SQL - provided by Docker image
[dcm4che/postgres-dcm4chee](https://hub.docker.com/r/dcm4che/postgres-dcm4chee/) -  it also depends
on a LDAP server - provided by Docker image
[dcm4che/slapd-dcm4che](https://hub.docker.com/r/dcm4che/slapd-dcm4chee/).

You may choose between
- a not secured version (Tag Name: `5.10.6`),
- a version with secured UI and secured RESTful services (Tag Name: `5.10.6-secure`),
- a version with secured UI, but not secured RESTful services (Tag Name: `5.10.6-secure-ui`),
- a not secured version with pre-configured [GELF Logger](http://logging.paluch.biz/examples/wildfly.html)
  to emit System logs to Logstash (Tag Name: `5.10.6-logstash`),
- a version with pre-configured [GELF Logger](http://logging.paluch.biz/examples/wildfly.html) and with secured UI
  and secured RESTful services (Tag Name: `5.10.6-logstash-secure`) and
- a version with pre-configured [GELF Logger](http://logging.paluch.biz/examples/wildfly.html) and with secured UI,
  but not secured RESTful services (Tag Name: `5.10.6-logstash-secure-ui`).

Before running the Archive container, you have to start a container providing the [LDAP server](https://github.com/dcm4che-dockerfiles/slapd-dcm4chee#how-to-use-this-image)
and a container providing the [database server](https://github.com/dcm4che-dockerfiles/postgres-dcm4chee#how-to-use-this-image)
and [Keycloak container](https://github.com/dcm4che-dockerfiles/keycloak#how-to-use-this-image)

If you want to store DCM4CHEE Archive 5's System logs and Audit Messages in [Elasticsearch](https://www.elastic.co/products/elasticsearch)
you have to also start containers providing [Elasticsearch, Logstash and Kibana](https://www.elastic.co/products):

```bash
> $docker run --name elasticsearch \
           -p 9200:9200 \
           -p 9300:9300 \
           -v /var/local/dcm4chee-arc/elasticsearch:/usr/share/elasticsearch/data \
           -d elasticsearch:5.2.2
```

```bash
> $docker run --name logstash \
           -p 12201:12201/udp \
           -p 8514:8514/udp \
           -p 8514:8514 \
           -v /var/local/dcm4chee-arc/elasticsearch:/usr/share/elasticsearch/data \
           --link elasticsearch:elasticsearch \
           -d dcm4che/logstash-dcm4chee:5.2.2-2
```

```bash
> $docker run --name kibana \
           -p 5601:5601 \
           --link elasticsearch:elasticsearch \
           -d kibana:5.2.2
```

You have to link the archive container with the _OpenLDAP_ (alias:`ldap`), the _PostgreSQL_ (alias:`db`) and 
the _Keycloak_ (alias:`keycloak`) containers :
```bash
> $docker run --name dcm4chee-arc \
           -p 8080:8080 \
           -p 9990:9990 \
           -p 11112:11112 \
           -p 2575:2575 \
           -v /var/local/dcm4chee-arc/wildfly:/opt/wildfly/standalone \
           -v /var/local/dcm4chee-arc/storage:/storage \
           --link slapd:ldap \
           --link postgres:db \
           --link keycloak:keycloak \
           -d dcm4che/dcm4chee-arc-psql:5.10.6-secure-ui
```

If you want to store DCM4CHEE Archive 5's System logs and Audit Messages in
[Elasticsearch](https://www.elastic.co/products/elasticsearch), you also have to link the archive container
with the _Logstash_ (alias:`logstash`) container:
```bash
> $docker run --name dcm4chee-arc \
           -p 8080:8080 \
           -p 9990:9990 \
           -p 11112:11112 \
           -p 2575:2575 \
           -v /var/local/dcm4chee-arc/wildfly:/opt/wildfly/standalone \
           -v /var/local/dcm4chee-arc/storage:/storage \
           --link slapd:ldap \
           --link postgres:db \
           --link keycloak:keycloak \
           --link logstash:logstash \
           -d dcm4che/dcm4chee-arc-psql:5.10.6-logstash-secure-ui
```

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

#### Use Docker Compose

Alternatively you may use [Docker Compose](https://docs.docker.com/compose/) to take care for starting and linking
the containers, by specifying the services in a configuration file `docker-compose.yml` (e.g.):

````yaml
version: "2"
services:
  slapd:
    image: dcm4che/slapd-dcm4chee:2.4.44-10.6
    ports:
      - "389:389"
    env_file: docker-compose.env
    volumes:
      - /etc/timezone:/etc/timezone
      - /etc/localtime:/etc/localtime
      - /var/local/dcm4chee-arc/ldap:/var/lib/ldap
      - /var/local/dcm4chee-arc/slapd.d:/etc/ldap/slapd.d
  postgres:
    image: dcm4che/postgres-dcm4chee:9.6-10
    ports:
      - "5432:5432"
    env_file: docker-compose.env
    volumes:
      - /etc/timezone:/etc/timezone
      - /etc/localtime:/etc/localtime
      - /var/local/dcm4chee-arc/db:/var/lib/postgresql/data
  elasticsearch:
    image: elasticsearch:5.2.2
    ports:
      - "9200:9200"
      - "9300:9300"
    volumes:
      - /etc/timezone:/etc/timezone
      - /etc/localtime:/etc/localtime
      - /var/local/dcm4chee-arc/elasticsearch:/usr/share/elasticsearch/data
  kibana:
    image: kibana:5.2.2
    ports:
      - "5601:5601"
    links:
      - elasticsearch:elasticsearch
    volumes:
      - /etc/timezone:/etc/timezone
      - /etc/localtime:/etc/localtime
  logstash:
    image: dcm4che/logstash-dcm4chee:5.2.2-2
    ports:
      - "12201:12201/udp"
      - "8514:8514/udp"
      - "8514:8514"
    links:
      - elasticsearch:elasticsearch
    volumes:
      - /etc/timezone:/etc/timezone
      - /etc/localtime:/etc/localtime
  keycloak:
      image: dcm4che/keycloak:3.2.1-1-logstash
      ports:
        - "8880:8880"
        - "8843:8843"
        - "8990:8990"
      env_file: docker-compose.env
      environment:
        HTTP_PORT: 8880
        HTTPS_PORT: 8843
        MANAGEMENT_HTTP_PORT: 8990
        KEYCLOAK_WAIT_FOR: ldap:389 logstash:8514
      links:
        - slapd:ldap
        - logstash:logstash
      volumes:
        - /etc/timezone:/etc/timezone
        - /etc/localtime:/etc/localtime
        - /var/local/dcm4chee-arc/keycloak:/opt/keycloak/standalone
  dcm4chee-arc:
    image: dcm4che/dcm4chee-arc-psql:5.10.6-logstash-secure-ui
    ports:
      - "8080:8080"
      - "9990:9990"
      - "11112:11112"
      - "2575:2575"
    env_file: docker-compose.env
    environment:
      WILDFLY_CHOWN: /opt/wildfly/standalone /storage
      WILDFLY_WAIT_FOR: ldap:389 db:5432 logstash:8514
      UI_CLIENT_ID: dcm4chee-arc-ui
      RS_CLIENT_ID: dcm4chee-arc-rs
    links:
      - slapd:ldap
      - postgres:db
      - logstash:logstash
      - keycloak:keycloak
    volumes:
      - /etc/timezone:/etc/timezone
      - /etc/localtime:/etc/localtime
      - /var/local/dcm4chee-arc/storage:/storage
      - /var/local/dcm4chee-arc/wildfly:/opt/wildfly/standalone
  keycloak-proxy:
      image: dcm4che/keycloak-proxy:3.2.1-1
      ports:
        - "8601:8601"
        - "8643:8643"
      env_file: docker-compose.env
      environment:
        HTTP_PORT: 8601
        HTTPS_PORT: 8643
        TARGET_URL: http://gunter-nb:5601
        CLIENT_ID: kibana
        ROLE_ALLOWED: auditlog
      links:
        - kibana:kibana
        - keycloak:keycloak
      volumes:
        - /etc/timezone:/etc/timezone
        - /etc/localtime:/etc/localtime
````

and environment in the referenced file `docker-compose.env` (e.g.):

````INI
LDAP_BASE_DN=dc=dcm4che,dc=org
LDAP_ORGANISATION=dcm4che.org
LDAP_ROOTPASS=secret
LDAP_CONFIGPASS=secret
POSTGRES_DB=pacsdb
POSTGRES_USER=pacs
POSTGRES_PASSWORD=pacs
ARCHIVE_DEVICE_NAME=dcm4chee-arc
AE_TITLE=DCM4CHEE
DICOM_HOST=localhost
DICOM_PORT=11112
HL7_PORT=2575
STORAGE_DIR=/storage/fs1
SYSLOG_DEVICE_NAME=logstash
SYSLOG_HOST=logstash
SYSLOG_PORT=8514
SYSLOG_PROTOCOL=TLS
KEYCLOAK_DEVICE_NAME=keycloak
REALM_NAME=dcm4che
AUTH_SERVER_URL=https://gunter-nb:8843/auth
````

and starting them by
```bash
> $docker-compose up -d
````

#### Web Service URLs
- Archive UI: <http://localhost:8080/dcm4chee-arc/ui2> - if secured, login with

    Username | Password | Role
    --- | --- | ---
    `user` | `user` | `user`
    `admin` | `admin` | `user` + `admin`
- Wildfly Administration Console: <http://localhost:9990>, login with Username: `admin`, Password: `admin`.
- Kibana UI: <http://localhost:5601>
- DICOM QIDO-RS Base URL: <http://localhost:8080/dcm4chee-arc/aets/DCM4CHEE/rs>
- DICOM STOW-RS Base URL: <http://localhost:8080/dcm4chee-arc/aets/DCM4CHEE/rs>
- DICOM WADO-RS Base URL: <http://localhost:8080/dcm4chee-arc/aets/DCM4CHEE/rs>
- DICOM WADO-URI: <http://localhost:8080/dcm4chee-arc/aets/DCM4CHEE/wado>
- IHE XDS-I Retrieve Imaging Document Set: <http://localhost:8080/dcm4chee-arc/xdsi/ImagingDocumentSource>
