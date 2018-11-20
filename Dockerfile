# Pull base image 
From tomcat:8-jre8 

# Maintainer 
MAINTAINER "support@secure-dimensions.de" 

# Copy to images tomcat path 
COPY authzforce-ce-server /opt/authzforce-ce-server/
ADD tomcat/conf/Catalina/localhost/authzforce-ce.xml /usr/local/tomcat/conf/Catalina/localhost/authzforce-ce.xml
ENV JAVA_OPTS="-Xmx1024m -Djavax.xml.accessExternalSchema=http,classpath"
EXPOSE 8080
CMD ["catalina.sh", "run"]
