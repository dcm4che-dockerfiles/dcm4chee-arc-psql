### dcm4chee-arc-psql Docker image

This is a Dockerfile with the DICOM Archive [dcm4chee-arc-light](https://github.com/dcm4che/dcm4chee-arc-light/wiki)
for use with Postgres SQL as database. Beside Postgres SQL - provided by Docker image
[dcm4che/postgres-dcm4chee](https://hub.docker.com/r/dcm4che/postgres-dcm4chee/) -  it also depends
on a LDAP server - provided by Docker image
[dcm4che/slapd-dcm4che](https://hub.docker.com/r/dcm4che/slapd-dcm4chee/).

You may choose between
- a not secured version (Tag Name: `5.0.1`),
- a version with secured UI and secured RESTful services (Tag Name: `5.0.1-secure`) and
- a version with secured UI, but not secured RESTful services (Tag Name: `5.0.1-secure-ui`).

#### Usage

Before starting the Archive container, you have to start a container providing the LDAP server, e.g:

    docker run --name ldap \
               -p 1389:389 \
               -e LDAP_BASE_DN=dc=mycorp,dc=com \
               -e LDAP_ORGANISATION="My Mega Corporation" \
               -e LDAP_ROOTPASS=mysecret \
               -e LDAP_CONFIGPASS=myconfigsecret \
               -e DEVICE_NAME=my-pacs \
               -e AE_TITLE=MYPACS \
               -e DICOM_HOST=localhost \
               -e DICOM_PORT=11112 \
               -e HL7_PORT=2575 \
               -e STORAGE_DIR=/var/local/mypacs/storage \
               -v /var/local/mypacs/ldap:/var/lib/ldap \
               -v /var/local/mypacs/slapd.d:/etc/ldap/slapd.d \
               -d dcm4che/slapd-dcm4chee:5.0.1

and another container providing the database:

    docker run --name db \
               -p 15432:5432 \
               -e POSTGRES_DB=pacsdb \
               -e POSTGRES_USER=pacs \
               -e POSTGRES_PASSWORD=pacsword \
               -v /var/local/mypacs/db:/var/lib/postgresql/data \
               -d dcm4che/postgres-dcm4chee:5.0.1

After that you can start the archive container, linked with the `ldap` and the `db` container:

    docker run --name mypacs \
               -p 8080:8080 \
               -p 9990:9990 \
               -p 11112:11112 \
               -p 2575:2575 \
               -v /var/local/mypacs/storage:/var/local/mypacs/storage \
               -v /var/local/mypacs/log:/opt/wildfly/standalone/log \
               -v /tmp:/opt/wildfly/standalone/tmp \
               --link ldap:ldap \
               --link db:db \
               -d dcm4che/dcm4chee-arc-psql:5.0.1-secure-ui

Alternatively you may use [Docker Composite](https://docs.docker.com/compose/) to take care for
starting and linking the 3 containers, by defining the services in
[docker-compose.yml](https://raw.githubusercontent.com/dcm4che-dockerfiles/dcm4chee-arc-psql/master/docker-compose.yml)
(e.g.):

````yaml
ldap:
  image: dcm4che/slapd-dcm4chee:5.0.1
  ports:
    - "1389:389"
  environment:
    LDAP_BASE_DN: dc=mycorp,dc=com
    LDAP_ORGANISATION: My Mega Corporation
    LDAP_ROOTPASS: mysecret
    LDAP_CONFIGPASS: myconfigsecret
    DEVICE_NAME: my-pacs
    AE_TITLE: MYPACS
    DICOM_HOST: localhost
    DICOM_PORT: 11112
    HL7_PORT: 2575
    STORAGE_DIR: /var/local/mypacs/storage
  volumes:
    - /var/local/mypacs/ldap:/var/lib/ldap
    - /var/local/mypacs/slapd.d:/etc/ldap/slapd.d
db:
  image: dcm4che/postgres-dcm4chee:5.0.1
  ports:
    - "15432:5432"
  environment:
    POSTGRES_DB: pacsdb
    POSTGRES_USER: pacs
    POSTGRES_PASSWORD: pacsword
  volumes:
    - /var/local/mypacs/db:/var/lib/postgresql/data
mypacs:
  image: dcm4che/dcm4chee-arc-psql:5.0.1-secure-ui
  ports:
    - "8080:8080"
    - "9990:9990"
    - "11112:11112"
    - "2575:2575"
  links:
    - ldap:ldap
    - db:db
  volumes:
    - /var/local/mypacs/storage:/var/local/mypacs/storage
    - /var/local/mypacs/log:/opt/wildfly/standalone/log
    - /tmp:/opt/wildfly/standalone/tmp
````

and starting them by

    docker-composite up

#### Web Service URLs

- Archive UI: <http://localhost:8080/dcm4chee-arc/ui> - if secured, login with Username: `user`, Password: `user`.
- Keycloak Administration Console: <http://localhost:8080/auth>, login with Username: `admin`, Password: `admin`.
- Wildfly Administration Console: <http://localhost:9990>, login with Username: `admin`, Password: `admin`.
- DICOM WADO-URI: <http://localhost:8080/dcm4chee-arc/aets/MYPACS/wado>
- DICOM QIDO-RS Base URL: <http://localhost:8080/dcm4chee-arc/aets/MYPACS/rs>
