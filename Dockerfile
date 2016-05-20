FROM dcm4che/wildfly:10.0.0.Final

ENV DCM4CHEE_ARC_VERSION 5.3.0
ENV DCM4CHE_VERSION dcm4chee-arc-light-${DCM4CHEE_ARC_VERSION}

RUN cd $JBOSS_HOME \
    && curl http://www.dcm4che.org/maven2/org/dcm4che/jai_imageio-jboss-modules/1.2-pre-dr-b04/jai_imageio-jboss-modules-1.2-pre-dr-b04.tar.gz | tar xz \
    && curl http://www.dcm4che.org/maven2/org/dcm4che/querydsl-jboss-modules/4.0.3-noguava/querydsl-jboss-modules-4.0.3-noguava.tar.gz | tar xz \
    && curl http://www.dcm4che.org/maven2/org/dcm4che/jclouds-jboss-modules/1.9.1-noguava/jclouds-jboss-modules-1.9.1-noguava.tar.gz | tar xz \
    && curl http://www.dcm4che.org/maven2/org/dcm4che/jdbc-jboss-modules/1.0.0/jdbc-jboss-modules-1.0.0-psql.tar.gz | tar xz \
    && curl http://www.dcm4che.org/maven2/org/dcm4che/dcm4che-jboss-modules/$DCM4CHE_VERSION/dcm4che-jboss-modules-${DCM4CHE_VERSION}.tar.gz | tar xz \
    && cd modules/org/postgresql/main \
    && curl -O https://jdbc.postgresql.org/download/postgresql-9.4-1206-jdbc41.jar \
    && cd /docker-entrypoint.d/deployments \
    && curl -O http://www.dcm4che.org/maven2/org/dcm4che/dcm4chee-arc/dcm4chee-arc-ear/${DCM4CHEE_ARC_VERSION}/dcm4chee-arc-ear-${DCM4CHEE_ARC_VERSION}-psql.ear

COPY configuration /docker-entrypoint.d/configuration

CMD ["standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c", "dcm4chee-arc.xml"]
