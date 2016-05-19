### dcm4chee-arc-psql Docker image

This is a Dockerfile with the DICOM Archive [dcm4chee-arc-light](https://github.com/dcm4che/dcm4chee-arc-light/wiki)
for use with Postgres SQL as database. Beside Postgres SQL - provided by Docker image
[dcm4che/postgres-dcm4chee](https://hub.docker.com/r/dcm4che/postgres-dcm4chee/) -  it also depends
on a LDAP server - provided by Docker image
[dcm4che/slapd-dcm4che](https://hub.docker.com/r/dcm4che/slapd-dcm4chee/).

You may choose between
- a not secured version (Tag Name: `5.2.1`),
- a version with secured UI and secured RESTful services (Tag Name: `5.2.1-secure`),
- a version with secured UI, but not secured RESTful services (Tag Name: `5.2.1-secure-ui`),
- a not secured version with pre-configured [GELF Logger](http://logging.paluch.biz/examples/wildfly.html)
  to emit System logs to Logstash (Tag Name: `5.2.1-logstash`),
- a version with pre-configured [GELF Logger](http://logging.paluch.biz/examples/wildfly.html) and with secured UI
  and secured RESTful services (Tag Name: `5.2.1-logstash-secure`) and
- a version with pre-configured [GELF Logger](http://logging.paluch.biz/examples/wildfly.html) and with secured UI,
  but not secured RESTful services (Tag Name: `5.2.1-logstash-secure-ui`).

#### Usage

Before starting the Archive container, you have to start a container providing the LDAP server, e.g:
```bash
> $docker run --name slapd \
           -p 389:389 \
           -e LDAP_BASE_DN=dc=dcm4che,dc=org \
           -e LDAP_ORGANISATION=dcm4che.org \
           -e LDAP_ROOTPASS=secret \
           -e LDAP_CONFIGPASS=secret \
           -e DEVICE_NAME=dcm4chee-arc \
           -e AE_TITLE=DCM4CHEE \
           -e DICOM_HOST=dockerhost \
           -e DICOM_PORT=11112 \
           -e HL7_PORT=2575 \
           -e STORAGE_DIR=/storage/fs1 \
           -v /var/local/dcm4chee-arc/ldap:/var/lib/ldap \
           -v /var/local/dcm4chee-arc/slapd.d:/etc/ldap/slapd.d \
           -d dcm4che/slapd-dcm4chee:5.2.1
````

and another container providing the database:
```bash
> $docker run --name postgres \
           -p 5432:5432 \
           -e POSTGRES_DB=pacsdb \
           -e POSTGRES_USER=pacs \
           -e POSTGRES_PASSWORD=pacs \
           -v /var/local/dcm4chee-arc/db:/var/lib/postgresql/data \
           -d dcm4che/postgres-dcm4chee:5.2.1
````

After that you can start the archive container, linked with the _OpenLDAP_ (alias:`ldap`) and
the _PostgreSQL_ (alias:`db`) container::
```bash
> $docker run --name dcm4chee-arc \
           -p 8080:8080 \
           -p 9990:9990 \
           -p 11112:11112 \
           -p 2575:2575 \
           -e LDAP_BASE_DN=dc=dcm4che,dc=org \
           -e LDAP_ROOTPASS=secret \
           -e DEVICE_NAME=dcm4chee-arc \
           -e POSTGRES_DB=pacsdb \
           -e POSTGRES_USER=pacs \
           -e POSTGRES_PASSWORD=pacs \
           -e WILDFLY_CHOWN=/opt/wildfly/standalone /storage
           -v /var/local/dcm4chee-arc/storage:/storage \
           -v /var/local/dcm4chee-arc/wildfly:/opt/wildfly/standalone \
           --link slapd:ldap \
           --link postgres:db \
           -d dcm4che/dcm4chee-arc-psql:5.2.1-secure-ui
```

Alternatively you may use [Docker Composite](https://docs.docker.com/compose/) to take care for
starting and linking the 3 containers, by defining the services in
[docker-compose.yml](https://raw.githubusercontent.com/dcm4che-dockerfiles/dcm4chee-arc-psql/master/docker-compose.yml)
(e.g.):

````yaml
version: "2"
services:
  slapd:
    image: dcm4che/slapd-dcm4chee:5.2.1
    ports:
      - "389:389"
    env_file: docker-compose.env
    volumes:
      - /etc/timezone:/etc/timezone
      - /etc/localtime:/etc/localtime
      - /var/local/dcm4chee-arc/ldap:/var/lib/ldap
      - /var/local/dcm4chee-arc/slapd.d:/etc/ldap/slapd.d
  postgres:
    image: dcm4che/postgres-dcm4chee:5.2
    ports:
      - "5432:5432"
    env_file: docker-compose.env
    volumes:
      - /etc/timezone:/etc/timezone
      - /etc/localtime:/etc/localtime
      - /var/local/dcm4chee-arc/db:/var/lib/postgresql/data
  dcm4chee-arc:
    image: dcm4che/dcm4chee-arc-psql:5.2.1
    ports:
      - "8080:8080"
      - "9990:9990"
      - "11112:11112"
      - "2575:2575"
    env_file: docker-compose.env
    environment:
      WILDFLY_CHOWN: /opt/wildfly/standalone /storage
      WILDFLY_WAIT_FOR: ldap:389 db:5432
    links:
      - slapd:ldap
      - postgres:db
    volumes:
      - /etc/timezone:/etc/timezone
      - /etc/localtime:/etc/localtime
      - /var/local/dcm4chee-arc/storage:/storage
      - /var/local/dcm4chee-arc/wildfly:/opt/wildfly/standalone
````

with environment variables defined in `docker-compose.env`:

````
LDAP_BASE_DN=dc=dcm4che,dc=org
LDAP_ORGANISATION=dcm4che.org
LDAP_ROOTPASS=secret
LDAP_CONFIGPASS=secret
DEVICE_NAME=dcm4chee-arc
AE_TITLE=DCM4CHEE
DICOM_HOST=localhost
DICOM_PORT=11112
HL7_PORT=2575
SYSLOG_HOST=localhost
SYSLOG_PORT=8514
STORAGE_DIR=/storage/fs1
POSTGRES_DB=pacsdb
POSTGRES_USER=pacs
POSTGRES_PASSWORD=pacs
````

and starting them by
```bash
> $docker-compose up -d
````

#### Web Service URLs
- Archive UI: <http://localhost:8080/dcm4chee-arc/ui> - if secured, login with

    Username | Password | Role
    --- | --- | ---
    `user` | `user` | `user`
    `admin` | `admin` | `user` + `admin`
- Keycloak Administration Console: <http://localhost:8080/auth>, login with Username: `admin`, Password: `admin`.
- Wildfly Administration Console: <http://localhost:9990>, login with Username: `admin`, Password: `admin`.
- Kibana UI: <http://localhost:5601>
- DICOM QIDO-RS Base URL: <http://localhost:8080/dcm4chee-arc/aets/DCM4CHEE/rs>
- DICOM STOW-RS Base URL: <http://localhost:8080/dcm4chee-arc/aets/DCM4CHEE/rs>
- DICOM WADO-RS Base URL: <http://localhost:8080/dcm4chee-arc/aets/DCM4CHEE/rs>
- DICOM WADO-URI: <http://localhost:8080/dcm4chee-arc/aets/DCM4CHEE/wado>
