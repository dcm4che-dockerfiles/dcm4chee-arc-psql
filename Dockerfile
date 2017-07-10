FROM dcm4che/wildfly:10.1.0.Final

ENV DCM4CHEE_ARC_VERSION 5.10.5
ENV DCM4CHE_VERSION dcm4chee-arc-light-${DCM4CHEE_ARC_VERSION}

RUN cd $JBOSS_HOME \
    && curl -f http://www.dcm4che.org/maven2/org/dcm4che/jai_imageio-jboss-modules/1.2-pre-dr-b04/jai_imageio-jboss-modules-1.2-pre-dr-b04.tar.gz | tar xz \
    && curl -f http://www.dcm4che.org/maven2/org/dcm4che/querydsl-jboss-modules/4.1.4-noguava/querydsl-jboss-modules-4.1.4-noguava.tar.gz | tar xz \
    && curl -f http://www.dcm4che.org/maven2/org/dcm4che/jclouds-jboss-modules/1.9.2-noguava/jclouds-jboss-modules-1.9.2-noguava.tar.gz | tar xz \
    && curl -f http://www.dcm4che.org/maven2/org/dcm4che/ecs-object-client-jboss-modules/3.0.0/ecs-object-client-jboss-modules-3.0.0.tar.gz | tar xz \
    && curl -f http://www.dcm4che.org/maven2/org/dcm4che/jdbc-jboss-modules/1.0.0/jdbc-jboss-modules-1.0.0-psql.tar.gz | tar xz \
    && curl -f http://www.dcm4che.org/maven2/org/dcm4che/dcm4che-jboss-modules/$DCM4CHE_VERSION/dcm4che-jboss-modules-${DCM4CHE_VERSION}.tar.gz | tar xz \
    && cd modules/org/postgresql/main \
    && curl -fO https://jdbc.postgresql.org/download/postgresql-9.4-1206-jdbc41.jar \
    && cd /docker-entrypoint.d/deployments \
    && curl -fO http://www.dcm4che.org/maven2/org/dcm4che/dcm4chee-arc/dcm4chee-arc-ear/${DCM4CHEE_ARC_VERSION}/dcm4chee-arc-ear-${DCM4CHEE_ARC_VERSION}-psql-secure-ui.ear

COPY configuration /docker-entrypoint.d/configuration

ENV WILDFLY_INIT $JBOSS_HOME/standalone/configuration/adjust-dcm4che-realm.sh

# Default configuration: can be overridden at the docker command line
ENV LDAP_HOST=ldap \
    LDAP_PORT=389 \
    LDAP_BASE_DN=dc=dcm4che,dc=org \
    LDAP_ROOTPASS=secret \
    POSTGRES_HOST=db \
    POSTGRES_PORT=5432 \
    POSTGRES_DB=pacsdb \
    POSTGRES_USER=pacs \
    POSTGRES_PASSWORD=pacs \
    WILDFLY_ADMIN_USER=admin \
    WILDFLY_EXECUTER_MAX_THREADS=100 \
    WILDFLY_PACSDS_MAX_POOL_SIZE=50 \
    ARCHIVE_DEVICE_NAME=dcm4chee-arc \
    SSL_REQUIRED=external \
    AUTH_SERVER_URL=/auth

 # Set the default command to run on boot
 # This will boot WildFly in the standalone mode and bind to all interface
CMD ["standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c", "dcm4chee-arc.xml", \
     "-Dkeycloak.migration.action=import", "-Dkeycloak.migration.provider=singleFile", \
     "-Dkeycloak.migration.file=/opt/wildfly/standalone/configuration/dcm4che-realm.json" ]
