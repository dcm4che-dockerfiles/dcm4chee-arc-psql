FROM dcm4che/wildfly:ffmpeg-26.1.1-18.0.2

ENV DCM4CHEE_ARC_VERSION 5.26.1
ENV DCM4CHE_VERSION ${DCM4CHEE_ARC_VERSION}

RUN cd $JBOSS_HOME \
    && curl -f https://www.dcm4che.org/maven2/org/dcm4che/jai_imageio-jboss-modules/1.2-pre-dr-b04/jai_imageio-jboss-modules-1.2-pre-dr-b04.tar.gz | tar xz \
    && curl -f https://www.dcm4che.org/maven2/org/dcm4che/jclouds-jboss-modules/2.5.0-noguava/jclouds-jboss-modules-2.5.0-noguava.tar.gz | tar xz \
    && curl -f https://www.dcm4che.org/maven2/org/dcm4che/ecs-object-client-jboss-modules/3.0.0/ecs-object-client-jboss-modules-3.0.0.tar.gz | tar xz \
    && curl -f https://www.dcm4che.org/maven2/org/dcm4che/jdbc-jboss-modules-psql/42.3.6/jdbc-jboss-modules-psql-42.3.6.tar.gz | tar xz \
    && curl -f https://www.dcm4che.org/maven2/org/dcm4che/dcm4che-jboss-modules/$DCM4CHE_VERSION/dcm4che-jboss-modules-${DCM4CHE_VERSION}.tar.gz | tar xz \
    && chown -R wildfly:wildfly $JBOSS_HOME/modules \
    && cd /docker-entrypoint.d/deployments \
    && curl -fO https://www.dcm4che.org/maven2/org/dcm4che/dcm4chee-arc/dcm4chee-arc-ui2/${DCM4CHEE_ARC_VERSION}/dcm4chee-arc-ui2-${DCM4CHEE_ARC_VERSION}.war \
    && curl -fO https://www.dcm4che.org/maven2/org/dcm4che/dcm4chee-arc/dcm4chee-arc-ear/${DCM4CHEE_ARC_VERSION}/dcm4chee-arc-ear-${DCM4CHEE_ARC_VERSION}-psql.ear \
    && chown wildfly:wildfly *

COPY setenv.sh /
COPY --chown=wildfly:wildfly configuration /docker-entrypoint.d/configuration

# Default configuration: can be overridden at the docker command line
ENV LDAP_URL=ldap://ldap:389 \
    LDAP_BASE_DN=dc=dcm4che,dc=org \
    KEYSTORE=/opt/wildfly/standalone/configuration/keystores/key.p12 \
    KEYSTORE_TYPE=PKCS12 \
    TRUSTSTORE=/opt/java/openjdk/lib/security/cacerts \
    TRUSTSTORE_TYPE=JKS \
    EXTRA_CACERTS=/opt/wildfly/standalone/configuration/keystores/cacerts.p12
