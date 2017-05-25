#!/bin/bash

echo "Initializing filebeat..."
nohup filebeat -e -c /app/filebeat.yml > /app/logs/filebeat.log 2>&1&
nohup consul agent -dev -advertise `ip -f inet addr | grep inet | grep eth0 | awk '{ print $2; }' | awk 'BEGIN { FS="/"; } { print $1;  }'` > /app/logs/consul.log 2>&1&
JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom $JAVA_OPTS"
if [ -z ${ENVIRONMENT+x} ]; then
  ARGS="--spring.profiles.active=default $ARGS"
else
  ARGS="--spring.profiles.active=$ENVIRONMENT $ARGS"
fi
echo "Initializing application $FILEBEAT_SHIPPER..."
echo "JAVA_OPTS: $JAVA_OPTS"
echo "ARGS: $ARGS"
java $JAVA_OPTS -jar /app/app.jar $ARGS
