FROM dcm4che/wildfly:ffmpeg-20.0.1-11.0.0

ENV DCM4CHEE_ARC_VERSION 5.22.4
ENV DCM4CHE_VERSION ${DCM4CHEE_ARC_VERSION}

RUN cd $JBOSS_HOME \
    && curl -f http://maven.dcm4che.org/org/dcm4che/jai_imageio-jboss-modules/1.2-pre-dr-b04/jai_imageio-jboss-modules-1.2-pre-dr-b04.tar.gz | tar xz \
    && curl -f http://maven.dcm4che.org/org/dcm4che/jclouds-jboss-modules/2.2.1-noguava/jclouds-jboss-modules-2.2.1-noguava.tar.gz | tar xz \
    && curl -f http://maven.dcm4che.org/org/dcm4che/ecs-object-client-jboss-modules/3.0.0/ecs-object-client-jboss-modules-3.0.0.tar.gz | tar xz \
    && curl -f http://maven.dcm4che.org/org/dcm4che/jdbc-jboss-modules-psql/42.2.12/jdbc-jboss-modules-psql-42.2.12.tar.gz | tar xz \
    && curl -f http://maven.dcm4che.org/org/dcm4che/dcm4che-jboss-modules/$DCM4CHE_VERSION/dcm4che-jboss-modules-${DCM4CHE_VERSION}.tar.gz | tar xz \
    && cd /docker-entrypoint.d/deployments \
    && curl -fO http://maven.dcm4che.org/org/dcm4che/dcm4chee-arc/dcm4chee-arc-ear/${DCM4CHEE_ARC_VERSION}/dcm4chee-arc-ear-${DCM4CHEE_ARC_VERSION}-psql-secure.ear

COPY setenv.sh /
COPY configuration /docker-entrypoint.d/configuration

# Default configuration: can be overridden at the docker command line
ENV LDAP_URL=ldap://ldap:389 \
    LDAP_BASE_DN=dc=dcm4che,dc=org \
    KEYSTORE=/opt/wildfly/standalone/configuration/keystores/key.jks \
    KEYSTORE_TYPE=JKS \
    TRUSTSTORE=/opt/wildfly/standalone/configuration/keystores/cacerts.jks
