[![](https://images.microbadger.com/badges/image/rodrigozc/jdk8-filebeat-consul.svg)](https://microbadger.com/images/rodrigozc/jdk8-filebeat-consul "Get your own image badge on microbadger.com")

[![](https://images.microbadger.com/badges/version/rodrigozc/jdk8-filebeat-consul.svg)](https://microbadger.com/images/rodrigozc/jdk8-filebeat-consul "Get your own version badge on microbadger.com")

# JDK8 + Filebeat + Consul

__Oracle JDK8, Filebeat and Consul Image__

This image comes with an example app that shows enviroment variables on http://localhost:8080/info, replace `/app/app.jar` by your aplication package.

  * [github](https://github.com/rodrigozc/jdk8-filebeat-consul)
  * [docker](https://hub.docker.com/r/rodrigozc/jdk8-filebeat-consul/)

#### Filebeat

Configure the variables below for Filebeat.

  * __FILEBEAT_NAME:__ The name of the shipper that publishes the network data. It can be used to group all the transactions sent by a single shipper in the web interface, default `unknown`.
  * __FILEBEAT_TAGS:__ The tags of the shipper are included in their own field with each transaction published, default `unknown`.
  * __FILEBEAT_HOSTS:__ The Logstash hosts.
  * __FILEBEAT_INDEX:__ Optional index name. The default index name is set to name of the beat in all lowercase.

#### Consul

No need configuration, the image starts Consul with command below.
 ```bash
 $ consul agent -dev -advertise `ip -f inet addr | grep inet | grep eth0 | awk '{ print $2; }' | awk 'BEGIN { FS="/"; } { print $1;  }'`
 ```

#### Usage

Command Line

```bash
$ docker run -it --name jdk8 -p 8080:8080 -e FILEBEAT_NAME=jdk8-filebeat-consul -e FILEBEAT_TAGS=example -e FILEBEAT_HOSTS=elkhost:5044 -e FILEBEAT_INDEX=example -v $PWD/application.jar:/app/app.jar --add-host=elkhost:10.100.2.1 rodrigozc/jdk8-filebeat-consul
```

Dockerfile

```docker
FROM rodrigozc/jdk8-filebeat-consul
MAINTAINER Rodrigo Zampieri Castilho <rodrigo.zampieri@gmail.com>

ENV FILEBEAT_NAME jdk8-filebeat-consul
ENV FILEBEAT_TAGS example
ENV FILEBEAT_HOSTS elkhost:5044
ENV FILEBEAT_INDEX example

ENV ARGS -Xmx512m

ADD application.jar /app/app.jar
ADD application.yml /app/application.yml
```
