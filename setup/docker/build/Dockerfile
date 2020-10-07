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
#	   $ ./buildKubeContainerImage.sh accounts
#
# Access:
#      # Access your Microservice running as DOCKER Container at
#           https://localhost:8080/kube/customers/info/index.html

# Pull base image
# ---------------
FROM parrotstream/centos-openjdk:8

# Maintainer
# ----------
MAINTAINER NAVIKCO <NAVIK.HUB@GMAIL.COM>

ARG kubeMicroservice

# KUBE Setup as Root
USER root
VOLUME ["/opt/mw/mount"]
RUN mkdir -p /opt/mw/apps/kube/
WORKDIR /opt/mw/apps/kube/
ADD ./ .

RUN ls -lRt

RUN echo "###BUILD :::>>> ${kubeMicroservice}"

#RUN cd apps/${kubeMicroservice}/

#RUN pwd

#RUN ls -al

#RUN wget https://services.gradle.org/distributions/gradle-6.3-bin.zip -P gradle/wrapper/

RUN ./apps/${kubeMicroservice}/gradle wrapper

RUN ./apps/${kubeMicroservice}/gradlew clean build

RUN ls -lRt

RUN mv apps/${kubeMicroservice}/build/libs/${kubeMicroservice}*.jar setup/docker/build/

#WORKDIR /opt/mw/apps/kube/

RUN ./setup/docker/build/bin/setupKUBE.sh ${kubeMicroservice}

# KUBE Docker Container Run as kubeadmin
USER kubeadmin

#WORKDIR /opt/mw/apps/kube/bin/
#Start KUBE Microservice with Elastic Search
ENTRYPOINT ["./setup/docker/build/bin/startKUBE.sh"]
