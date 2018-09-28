FROM dcm4che/wildfly:12.0.0-4.4.0

ENV DCM4CHEE_ARC_VERSION 5.14.1
ENV DCM4CHE_VERSION ${DCM4CHEE_ARC_VERSION}

RUN cd $JBOSS_HOME \
    && curl -f http://maven.dcm4che.org/org/dcm4che/jai_imageio-jboss-modules/1.2-pre-dr-b04/jai_imageio-jboss-modules-1.2-pre-dr-b04.tar.gz | tar xz \
    && curl -f http://maven.dcm4che.org/org/dcm4che/querydsl-jboss-modules/4.2.1-noguava/querydsl-jboss-modules-4.2.1-noguava.tar.gz | tar xz \
    && curl -f http://maven.dcm4che.org/org/dcm4che/jclouds-jboss-modules/2.1.1-noguava/jclouds-jboss-modules-2.1.1-noguava.tar.gz | tar xz \
    && curl -f http://maven.dcm4che.org/org/dcm4che/ecs-object-client-jboss-modules/3.0.0/ecs-object-client-jboss-modules-3.0.0.tar.gz | tar xz \
    && curl -f http://maven.dcm4che.org/org/dcm4che/jdbc-jboss-modules/1.0.0/jdbc-jboss-modules-1.0.0-psql.tar.gz | tar xz \
    && curl -f http://maven.dcm4che.org/org/dcm4che/dcm4che-jboss-modules/$DCM4CHE_VERSION/dcm4che-jboss-modules-${DCM4CHE_VERSION}.tar.gz | tar xz \
    && cd modules/org/postgresql/main \
    && curl -fO https://jdbc.postgresql.org/download/postgresql-42.1.4.jar \
    && cd /docker-entrypoint.d/deployments \
    && curl -fO http://maven.dcm4che.org/org/dcm4che/dcm4chee-arc/dcm4chee-arc-ear/${DCM4CHEE_ARC_VERSION}/dcm4chee-arc-ear-${DCM4CHEE_ARC_VERSION}-psql-secure.ear

COPY configuration /docker-entrypoint.d/configuration

# Default configuration: can be overridden at the docker command line
ENV LDAP_URL=ldap://ldap:389 \
    LDAP_BASE_DN=dc=dcm4che,dc=org \
    LDAP_ROOTPASS=secret \
    LDAP_ROOTPASS_FILE=/tmp/ldap_rootpass \
    POSTGRES_HOST=db \
    POSTGRES_PORT=5432 \
    POSTGRES_DB=pacsdb \
    POSTGRES_USER=pacs \
    POSTGRES_PASSWORD=pacs \
    POSTGRES_PASSWORD_FILE=/tmp/postgres_password \
    ARCHIVE_DEVICE_NAME=dcm4chee-arc \
    REVERSE_DNS=true \
    HTTP_PORT=8080 \
    HTTPS_PORT=8443 \
    MANAGEMENT_HTTP_PORT=9990 \
    KEYSTORE=dcm4chee-arc/key.jks \
    KEYSTORE_PASSWORD=secret \
    KEYSTORE_PASSWORD_FILE=/tmp/keystore_password \
    KEY_PASSWORD=secret \
    KEY_PASSWORD_FILE=/tmp/key_password \
    KEYSTORE_TYPE=JKS \
    TRUSTSTORE=dcm4chee-arc/cacerts.jks \
    TRUSTSTORE_PASSWORD=secret \
    TRUSTSTORE_PASSWORD_FILE=/tmp/truststore_password \
    SSL_REQUIRED=external \
    REALM_NAME=dcm4che \
    SUPER_USER_ROLE=admin \
    ALLOW_ANY_HOSTNAME=true \
    AUTH_SERVER_URL=http://keycloak:8080/auth \
    UI_CLIENT_ID=dcm4chee-arc-ui \
    RS_CLIENT_ID=dcm4chee-arc-rs \
    WILDFLY_EXECUTER_MAX_THREADS=100 \
    WILDFLY_PACSDS_MAX_POOL_SIZE=50 \
    WILDFLY_MDB_STRICT_MAX_POOL_SIZE=32 \
    WILDFLY_DISABLE_CACHING_FOR_SECURED_PAGES=false \
    WILDFLY_JMS_QUEUE_STGCMTSCP_CONSUMER_COUNT=1 \
    WILDFLY_JMS_QUEUE_STGCMTSCU_CONSUMER_COUNT=1 \
    WILDFLY_JMS_QUEUE_STGVERTASKS_CONSUMER_COUNT=1 \
    WILDFLY_JMS_QUEUE_MPPSSCU_CONSUMER_COUNT=1 \
    WILDFLY_JMS_QUEUE_IANSCU_CONSUMER_COUNT=1 \
    WILDFLY_JMS_QUEUE_EXPORT1_CONSUMER_COUNT=1 \
    WILDFLY_JMS_QUEUE_EXPORT2_CONSUMER_COUNT=1 \
    WILDFLY_JMS_QUEUE_EXPORT3_CONSUMER_COUNT=1 \
    WILDFLY_JMS_QUEUE_EXPORT4_CONSUMER_COUNT=1 \
    WILDFLY_JMS_QUEUE_EXPORT5_CONSUMER_COUNT=1 \
    WILDFLY_JMS_QUEUE_HL7SEND_CONSUMER_COUNT=1 \
    WILDFLY_JMS_QUEUE_RSCLIENT_CONSUMER_COUNT=1 \
    WILDFLY_JMS_QUEUE_CMOVESCU_CONSUMER_COUNT=1 \
    WILDFLY_JMS_QUEUE_DIFFTASKS_CONSUMER_COUNT=1

 # Set the default command to run on boot
 # This will boot WildFly in the standalone mode and bind to all interface
CMD ["standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c", "dcm4chee-arc.xml" ]
