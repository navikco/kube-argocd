# LICENSE CDDL 1.0 + GPL 2.0 + SECURUS-MW-KUBE 1.0
#
# KUBE DOCKER
# ----------
# This Dockerfile extends CentOS 7 OpenJDK 8 as Base Image
# It builds KUBE Microservice on top of it with Configurable -
    ## Environment / Active Profile (freeride, green, blue etc.)
    ## Microservice (${kubeMicroservice}, esp-rules etc.)
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Clone/Checkout All KUBE Microservices Project from GitHub
# Checkout Bitbucket Repo for KUBE/ESP Microservice - https://github.com/navikco/kube-ingress.git
#
# Run:
#      $ cd kube-ingress/setup/scripts/
#	   $ ./buildKubeContainerImage.sh users
#
# Access:
#      # Access your Microservice running as DOCKER Container at
#           https://localhost:8080/kube/users/info/index.html


FROM gradle:jdk8 AS builder
WORKDIR /workspace
ADD ./ .
RUN cd apps/users/ && gradle clean build && ls -ltr build/libs/


# Pull base image
# ---------------
FROM fabric8/java-alpine-openjdk8-jre

# Maintainer
# ----------
MAINTAINER NAVIKCO <NAVIK.HUB@GMAIL.COM>

# KUBE Setup as Root
#USER root
VOLUME ["/opt/mw/mount"]
RUN mkdir -p /opt/mw/apps/kube/
WORKDIR /opt/mw/apps/kube/
#ADD setup/docker/build/bin/ .

RUN echo "###BUILD :::>>> users"

# Setup Pod Timezone
# ------------------
RUN apk add tzdata && ls /usr/share/zoneinfo && cp /usr/share/zoneinfo/America/Chicago /etc/localtime && echo "America/Chicago" >  /etc/timezone && date && apk del tzdata

COPY --from=builder /workspace/apps/users/build/libs/users*.jar .
COPY --from=builder /workspace/apps/users/src/main/resources/logback-spring.xml .
COPY --from=builder /workspace/apps/users/src/main/resources/startKUBE.sh .

#RUN pwd && ls -lRt

RUN adduser -g kubeusers -s /bin/sh kubeusers -D && echo 'kubeusers:p@ss10n' | chpasswd && chown kubeusers:kubeusers -R /opt/mw/ && chmod 775 -R /opt/mw/ && ls -lRt

# KUBE Docker Container Run as kubeusers
USER kubeusers

#WORKDIR /opt/mw/apps/kube/

#Start KUBE Microservice with Elastic Search
#ENTRYPOINT ["java", "-jar", "users-*.jar", "-Dserver.port=8080", "-DKUBE_ADMIN_HOST=${2}", "-DKUBE_ADMIN_PORT=${3}", "-DKUBE_PROFILE=${1}", "-Dspring.profiles.active=${1}", "-Dserver.ssl.enabled=false" ]
ENTRYPOINT ["./startKUBE.sh"]
