#!/bin/bash

echo "Initializing filebeat..."
nohup /app/filebeat -e -d "*" -c /app/filebeat.yml > /app/logs/filebeat.log 2>&1&
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
