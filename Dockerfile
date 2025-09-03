FROM dcm4che/wildfly:37.0.0

ENV DCM4CHEE_ARC_VERSION=5.34.1
ENV DCM4CHE_VERSION=${DCM4CHEE_ARC_VERSION}

RUN set -eux \
    && if [ "$(uname -m)" = "x86_64" ]; then arch=amd64; else arch=arm64; fi \
    && mkdir ffmpeg && cd ffmpeg \
    && curl -L https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-${arch}-static.tar.xz | tar xJ \
    && mv $(ls) /opt/ffmpeg \
    && cd .. && rmdir ffmpeg \
    && ln -s /opt/ffmpeg/ffmpeg /usr/bin/ffmpeg \
    && cd $JBOSS_HOME \
    && curl -f https://www.dcm4che.org/maven2/org/dcm4che/jai_imageio-jboss-modules/1.2-pre-dr-b04/jai_imageio-jboss-modules-1.2-pre-dr-b04.tar.gz | tar xz \
    && curl -f https://www.dcm4che.org/maven2/org/dcm4che/jclouds-jboss-modules/2.6.0/jclouds-jboss-modules-2.6.0.tar.gz | tar xz \
    && curl -f https://www.dcm4che.org/maven2/org/dcm4che/jdbc-jboss-modules-psql/42.7.3/jdbc-jboss-modules-psql-42.7.3.tar.gz | tar xz \
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
    TRUSTSTORE=$JAVA_HOME/lib/security/cacerts \
    TRUSTSTORE_TYPE=JKS \
    EXTRA_CACERTS=/opt/wildfly/standalone/configuration/keystores/cacerts.p12 \
    WILDFLY_CONFIGURATION_VERSION=$DCM4CHEE_ARC_VERSION
