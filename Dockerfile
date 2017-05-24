FROM debian:jessie-slim
MAINTAINER Rodrigo Zampieri Castilho <rodrigo.zampieri@gmail.com>

# Install Oracle Java (auto accept licence)
RUN mkdir -p /usr/share/man/man1 \
    && mkdir -p /usr/share/binfmts \
    && echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list \
    && echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 \
    && apt-get update \
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
    && apt-get install -y --no-install-recommends oracle-java8-installer locales

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup locale and lang
RUN echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen pt_BR.UTF-8
ENV LC_ALL "pt_BR.UTF-8"
ENV LANG "pt_BR.UTF-8"
ENV LANGUAGE "pt_BR.UTF-8"
RUN rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

# Application specific
WORKDIR /app
RUN mkdir data \
    && mkdir logs
ADD app.jar app.jar
ADD application.yml application.yml
ADD filebeat* /app/
ADD docker-entrypoint.sh /app/

ENTRYPOINT ["sh","docker-entrypoint.sh"]
