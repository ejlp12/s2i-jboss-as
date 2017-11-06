# This image provides a base for building and running Jboss AS applications.
# It builds using maven and runs the resulting artifacts on JBoss AS 7.1.1 Final

FROM openshift/base-centos7

MAINTAINER Ejlp12 <ejlp12@gmail.com> 

EXPOSE 8080

ENV JBOSSAS_VERSION=7.1.1.Final \
    MAVEN_VERSION=3.3.9

LABEL io.k8s.description="Platform for building and running JEE applications on JBoss AS 7.1.1.Final" \
      io.k8s.display-name="JBoss AS 7.1.1.Final" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,jboss-as,jboss-as-7.1.1" \
      io.openshift.s2i.destination="/opt/s2i/destination" \
      com.redhat.deployments-dir="/jboss-as/standalone/deployments"

    
# Install Maven, JBoss AS 7.1.1 
RUN INSTALL_PKGS="wget tar unzip bc which lsof java-1.7.0-openjdk java-1.7.0-openjdk-devel" && \
    yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    (curl -v https://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | \
    tar -zx -C /usr/local) && \
    ln -sf /usr/local/apache-maven-$MAVEN_VERSION/bin/mvn /usr/local/bin/mvn && \
    mkdir -p $HOME/.m2 

RUN (curl -v http://10.100.93.198/jboss-as-$JBOSSAS_VERSION/jboss-as-$JBOSSAS_VERSION.tar.gz | tar zx -C / ) && \
     mv /jboss-as-$JBOSSAS_VERSION /jboss-as && \
     mkdir -p /opt/s2i/destination

# Add s2i JBoss AS customizations
ADD ./contrib/jbossmodules/ /jboss-as/modules/
ADD ./contrib/jbossbin/standalone.conf /jboss-as/bin/standalone.conf
ADD ./contrib/jbosscfg/standalone-openshift.xml /jboss-as/standalone/configuration/standalone-openshift.xml
ADD ./contrib/settings.xml $HOME/.m2/

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

RUN chown -R 1001:0 /jboss-as && chown -R 1001:0 $HOME && \
    chmod -R ug+rw /jboss-as && \
    chmod -R g+rw /opt/s2i/destination

USER 1001

CMD $STI_SCRIPTS_PATH/usage
