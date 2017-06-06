#!/bin/bash +e

memcached -d  -p 11211 -m 512 -u root


env_mode='';
env_mode=`printenv bo.custom.environment`
echo $env_mode;
if [ "$env_mode" == "STAGING" ]; then
echo  Staging or Dev mode;
#sed -i '/<Service name="Catalina">/a <Connector SSLEnabled="true" clientAuth="false" connectionTimeout="1200000"  keyAlias="development" keystoreFile="/opt/development.jks" keystorePass="syncoms" maxHttpHeaderSize="19999999998192" maxThreads="2000" port="443" protocol="org.apache.coyote.http11.Http11Protocol" scheme="https" secure="true" />'  /opt/tomcat/conf/server.xml
echo "Tomcat SSL configuration updated"

elif [ "$env_mode" == "PRODUCTION" ]; then
echo Production mode;
sed -i '/<Service name="Catalina">/a <Connector SSLEnabled="true" clientAuth="false" keyAlias="symphoni" keystoreFile="/opt/symphoni.jks" keystorePass="syncoms" maxHttpHeaderSize="8192" maxThreads="150" port="443" protocol="org.apache.coyote.http11.Http11Protocol" scheme="https" secure="true" />'  /opt/tomcat/conf/server.xml
echo "Tomcat SSL configuration updated"
else
echo  "No  environment is set. entering default mode which is production "
sed -i '/<Service name="Catalina">/a <Connector SSLEnabled="true" clientAuth="false" keyAlias="symphoni" keystoreFile="/opt/symphoni.jks" keystorePass="syncoms" maxHttpHeaderSize="8192" maxThreads="150" port="443" protocol="org.apache.coyote.http11.Http11Protocol" scheme="https" secure="true" />'  /opt/tomcat/conf/server.xml
echo "Tomcat SSL configuration updated"
fi

sh /opt/tomcat/bin/catalina.sh run

