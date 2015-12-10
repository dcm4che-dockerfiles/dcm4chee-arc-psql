FROM dcm4che/wildfly

RUN cd $JBOSS_HOME \
    && curl -O http://www.dcm4che.org/maven2/org/dcm4che/jai_imageio-jboss-modules/1.2-pre-dr-b04/jai_imageio-jboss-modules-1.2-pre-dr-b04.tar.gz \
    && curl -O http://www.dcm4che.org/maven2/org/dcm4che/querydsl-jboss-modules/4.0.3-noguava/querydsl-jboss-modules-4.0.3-noguava.tar.gz \
    && curl -O http://www.dcm4che.org/maven2/org/dcm4che/jclouds-jboss-modules/1.9.1-noguava/jclouds-jboss-modules-1.9.1-noguava.tar.gz \
    && curl -O http://www.dcm4che.org/maven2/org/dcm4che/jdbc-jboss-modules/1.0.0/jdbc-jboss-modules-1.0.0-psql.tar.gz \
    && tar xf jai_imageio-jboss-modules-1.2-pre-dr-b04.tar.gz \
    && tar xf querydsl-jboss-modules-4.0.3-noguava.tar.gz \
    && tar xf jclouds-jboss-modules-1.9.1-noguava.tar.gz \
    && tar xf jdbc-jboss-modules-1.0.0-psql.tar.gz \
    && rm *.tar.gz \
    && cd modules/org/postgresql/main \
    && curl -O https://jdbc.postgresql.org/download/postgresql-9.4-1206-jdbc41.jar

COPY configuration $JBOSS_HOME/standalone/configuration

RUN cd $JBOSS_HOME \
    && curl -O http://www.dcm4che.org/maven2/org/dcm4che/dcm4che-jboss-modules/5.0.1-dcm4chee-arc-light-SNAPSHOT/dcm4che-jboss-modules-5.0.1-dcm4chee-arc-light-20151209.205115-1.tar.gz \
    && tar xf dcm4che-jboss-modules-5.0.1-dcm4chee-arc-light-20151209.205115-1.tar.gz \
    && rm *.tar.gz \
    && cd standalone/deployments \
    && curl -O http://www.dcm4che.org/maven2/org/dcm4che/dcm4chee-arc/dcm4chee-arc-ear/5.0.1-SNAPSHOT/dcm4chee-arc-ear-5.0.1-20151210.004245-3-psql.ear

 # Expose the ports we're interested in
EXPOSE 11112 2575

 # Set the default command to run on boot
 # This will boot WildFly in the standalone mode and bind to all interface
CMD ["/opt/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-c", "dcm4chee-arc.xml"]
