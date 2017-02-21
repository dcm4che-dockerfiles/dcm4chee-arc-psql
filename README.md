### dcm4chee-arc-psql Docker image

This is a Dockerfile with the DICOM Archive [dcm4chee-arc-light](https://github.com/dcm4che/dcm4chee-arc-light/wiki)
for use with Postgres SQL as database. Beside Postgres SQL - provided by Docker image
[dcm4che/postgres-dcm4chee](https://hub.docker.com/r/dcm4che/postgres-dcm4chee/) -  it also depends
on a LDAP server - provided by Docker image
[dcm4che/slapd-dcm4che](https://hub.docker.com/r/dcm4che/slapd-dcm4chee/).

You may choose between
- a not secured version (Tag Name: `5.9.2`),
- a version with secured UI and secured RESTful services (Tag Name: `5.9.2-secure`),
- a version with secured UI, but not secured RESTful services (Tag Name: `5.9.2-secure-ui`),
- a not secured version with pre-configured [GELF Logger](http://logging.paluch.biz/examples/wildfly.html)
  to emit System logs to Logstash (Tag Name: `5.9.2-logstash`),
- a version with pre-configured [GELF Logger](http://logging.paluch.biz/examples/wildfly.html) and with secured UI
  and secured RESTful services (Tag Name: `5.9.2-logstash-secure`) and
- a version with pre-configured [GELF Logger](http://logging.paluch.biz/examples/wildfly.html) and with secured UI,
  but not secured RESTful services (Tag Name: `5.9.2-logstash-secure-ui`).

Before running the Archive container, you have to start a container providing the LDAP server, e.g:
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
           -e SYSLOG_HOST=logstash \
           -e SYSLOG_PORT=8512 \
           -e SYSLOG_PROTOCOL=UDP \
           -e STORAGE_DIR=/storage/fs1 \
           -v /var/local/dcm4chee-arc/ldap:/var/lib/ldap \
           -v /var/local/dcm4chee-arc/slapd.d:/etc/ldap/slapd.d \
           -d dcm4che/slapd-dcm4chee:2.4.40-9.2
````

and a container providing the database server, e.g:
```bash
> $docker run --name postgres \
           -p 5432:5432 \
           -e POSTGRES_DB=pacsdb \
           -e POSTGRES_USER=pacs\
           -e POSTGRES_PASSWORD=pacs \
           -v /var/local/dcm4chee-arc/db:/var/lib/postgresql/data \
           -d dcm4che/postgres-dcm4chee:9.6-9
````

If you want to store DCM4CHEE Archive 5's System logs and Audit Messages in [Elasticsearch](https://www.elastic.co/products/elasticsearch)
you have to also start containers providing [Elasticsearch, Logstash and Kibana](https://www.elastic.co/products):

```bash
> $docker run --name elasticsearch \
           -p 9200:9200 \
           -p 9300:9300 \
           -v /var/local/dcm4chee-arc/elasticsearch:/usr/share/elasticsearch/data \
           -d elasticsearch:2.4
```

```bash
> $docker run --name logstash \
           -p 12201:12201/udp \
           -p 8514:8514/udp \
           -p 8514:8514 \
           -v /var/local/dcm4chee-arc/elasticsearch:/usr/share/elasticsearch/data \
           --link elasticsearch:elasticsearch \
           -d dcm4che/logstash-dcm4chee:2.4-0
```

```bash
> $docker run --name kibana \
           -p 5601:5601 \
           --link elasticsearch:elasticsearch \
           -d kibana:4.6
```

You have to link the archive container with the _OpenLDAP_ (alias:`ldap`) and the _PostgreSQL_ (alias:`db`) container:
```bash
> $docker run --name dcm4chee-arc \
           -p 8080:8080 \
           -p 9990:9990 \
           -p 11112:11112 \
           -p 2575:2575 \
           -e LDAP_BASE_DN=dc=dcm4che,dc=org \
           -e LDAP_ROOTPASS=secret \
           -e LDAP_CONFIGPASS=secret \
           -e ARCHIVE_DEVICE_NAME=dcm4chee-arc \
           -e POSTGRES_DB=pacsdb \
           -e POSTGRES_USER=pacs\
           -e POSTGRES_PASSWORD=pacs \
           -e JAVA_OPTS="-Xms64m -Xmx512m -XX:MetaspaceSize=96M -XX:MaxMetaspaceSize=256m -Djava.net.preferIPv4Stack=true -Djboss.modules.system.pkgs=org.jboss.byteman -Djava.awt.headless=true" \
           -e WILDFLY_CHOWN="/opt/wildfly/standalone /storage" \
           -v /var/local/dcm4chee-arc/wildfly:/opt/wildfly/standalone \
           -v /var/local/dcm4chee-arc/storage:/storage \
           --link slapd:ldap \
           --link postgres:db \
           -d dcm4che/dcm4chee-arc-psql:5.9.2-secure-ui
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
           -e LDAP_BASE_DN=dc=dcm4che,dc=org \
           -e LDAP_ROOTPASS=secret \
           -e LDAP_CONFIGPASS=secret \
           -e ARCHIVE_DEVICE_NAME=dcm4chee-arc \
           -e POSTGRES_DB=pacsdb \
           -e POSTGRES_USER=pacs\
           -e POSTGRES_PASSWORD=pacs \
           -e JAVA_OPTS="-Xms64m -Xmx512m -XX:MetaspaceSize=96M -XX:MaxMetaspaceSize=256m -Djava.net.preferIPv4Stack=true -Djboss.modules.system.pkgs=org.jboss.byteman -Djava.awt.headless=true" \
           -e WILDFLY_CHOWN="/opt/wildfly/standalone /storage" \
           -v /var/local/dcm4chee-arc/wildfly:/opt/wildfly/standalone \
           -v /var/local/dcm4chee-arc/storage:/storage \
           --link slapd:ldap \
           --link postgres:db \
           --link logstash:logstash \
           -d dcm4che/dcm4chee-arc-psql:5.9.2-logstash-secure-ui
```

#### Use Docker Compose

Alternatively you may use [Docker Compose](https://docs.docker.com/compose/) to take care for starting and linking
the containers, by specifying the services in a configuration file `docker-compose.yml` (e.g.):

````yaml
version: "2"
services:
  slapd:
    image: dcm4che/slapd-dcm4chee:2.4.40-9.2
    ports:
      - "389:389"
    env_file: docker-compose.env
    volumes:
      - /etc/timezone:/etc/timezone
      - /etc/localtime:/etc/localtime
      - /var/local/dcm4chee-arc/ldap:/var/lib/ldap
      - /var/local/dcm4chee-arc/slapd.d:/etc/ldap/slapd.d
  postgres:
    image: dcm4che/postgres-dcm4chee:9.6-9
    ports:
      - "5432:5432"
    env_file: docker-compose.env
    volumes:
      - /etc/timezone:/etc/timezone
      - /etc/localtime:/etc/localtime
      - /var/local/dcm4chee-arc/db:/var/lib/postgresql/data
  elasticsearch:
    image: elasticsearch:2.4
    ports:
      - "9200:9200"
      - "9300:9300"
    volumes:
      - /etc/timezone:/etc/timezone
      - /etc/localtime:/etc/localtime
      - /var/local/dcm4chee-arc/elasticsearch:/usr/share/elasticsearch/data
  kibana:
    image: kibana:4.6
    ports:
      - "5601:5601"
    links:
      - elasticsearch:elasticsearch
    volumes:
      - /etc/timezone:/etc/timezone
      - /etc/localtime:/etc/localtime
  logstash:
    image: dcm4che/logstash-dcm4chee:2.4-0
    ports:
      - "12201:12201/udp"
      - "8514:8514/udp"
      - "8514:8514"
    links:
      - elasticsearch:elasticsearch
    volumes:
      - /etc/timezone:/etc/timezone
      - /etc/localtime:/etc/localtime
  dcm4chee-arc:
    image: dcm4che/dcm4chee-arc-psql:5.9.2-logstash-secure-ui
    ports:
      - "8080:8080"
      - "9990:9990"
      - "11112:11112"
      - "2575:2575"
    env_file: docker-compose.env
    environment:
      WILDFLY_CHOWN: /opt/wildfly/standalone /storage
      WILDFLY_WAIT_FOR: ldap:389 db:5432 logstash:8514
      AUTH_SERVER_URL: /auth
    links:
      - slapd:ldap
      - postgres:db
      - logstash:logstash
    volumes:
      - /etc/timezone:/etc/timezone
      - /etc/localtime:/etc/localtime
      - /var/local/dcm4chee-arc/storage:/storage
      - /var/local/dcm4chee-arc/wildfly:/opt/wildfly/standalone
````

and environment in the referenced file `docker-compose.env` (e.g.):

````INI
LDAP_BASE_DN=dc=dcm4che,dc=org
LDAP_ORGANISATION=dcm4che.org
LDAP_ROOTPASS=secret
LDAP_CONFIGPASS=secret
ARCHIVE_DEVICE_NAME=dcm4chee-arc
AE_TITLE=DCM4CHEE
DICOM_HOST=localhost
DICOM_PORT=11112
HL7_PORT=2575
SYSLOG_HOST=logstash
SYSLOG_PORT=8514
SYSLOG_PROTOCOL=TLS
STORAGE_DIR=/storage/fs1
POSTGRES_DB=pacsdb
POSTGRES_USER=pacs
POSTGRES_PASSWORD=pacs
KEYCLOAK_ADMIN_USER=admin
KEYCLOAK_ADMIN_PASSWORD=admin
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
- IHE XDS-I Retrieve Imaging Document Set: <http://localhost:8080/dcm4chee-arc/xdsi/ImagingDocumentSource>
