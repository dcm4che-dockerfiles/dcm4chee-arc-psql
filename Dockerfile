FROM dcm4che/wildfly:16.0.0-6.0.1

ENV DCM4CHEE_ARC_VERSION 5.17.0
ENV DCM4CHE_VERSION ${DCM4CHEE_ARC_VERSION}

RUN cd $JBOSS_HOME \
    && curl -f http://maven.dcm4che.org/org/dcm4che/jai_imageio-jboss-modules/1.2-pre-dr-b04/jai_imageio-jboss-modules-1.2-pre-dr-b04.tar.gz | tar xz \
    && curl -f http://maven.dcm4che.org/org/dcm4che/jclouds-jboss-modules/2.1.2-noguava/jclouds-jboss-modules-2.1.2-noguava.tar.gz | tar xz \
    && curl -f http://maven.dcm4che.org/org/dcm4che/ecs-object-client-jboss-modules/3.0.0/ecs-object-client-jboss-modules-3.0.0.tar.gz | tar xz \
    && curl -f http://maven.dcm4che.org/org/dcm4che/jdbc-jboss-modules/1.0.0/jdbc-jboss-modules-1.0.0-psql.tar.gz | tar xz \
    && curl -f http://maven.dcm4che.org/org/dcm4che/dcm4che-jboss-modules/$DCM4CHE_VERSION/dcm4che-jboss-modules-${DCM4CHE_VERSION}.tar.gz | tar xz \
    && cd modules/org/postgresql/main \
    && curl -fO https://jdbc.postgresql.org/download/postgresql-42.2.5.jar \
    && cd /docker-entrypoint.d/deployments \
    && curl -fO http://maven.dcm4che.org/org/dcm4che/dcm4chee-arc/dcm4chee-arc-ear/${DCM4CHEE_ARC_VERSION}/dcm4chee-arc-ear-${DCM4CHEE_ARC_VERSION}-psql.ear

COPY setenv.sh /
COPY configuration /docker-entrypoint.d/configuration

# Default configuration: can be overridden at the docker command line
ENV LDAP_URL=ldap://ldap:389 \
    LDAP_BASE_DN=dc=dcm4che,dc=org \
    KEYSTORE=/opt/wildfly/standalone/configuration/keystores/key.jks \
    TRUSTSTORE=/opt/wildfly/standalone/configuration/keystores/cacerts.jks
