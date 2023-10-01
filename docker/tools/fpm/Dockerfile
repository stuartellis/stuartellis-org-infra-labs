ARG DOCKER_IMAGE_BASE=ubuntu:focal

FROM ${DOCKER_IMAGE_BASE}

RUN apt update && \
   apt -y install python3-dev python3-virtualenv apt-transport-https curl gnupg ruby rubygems-integration ruby-dev build-essential rsync && \
   apt -y upgrade && \
   apt autoremove && \
   apt clean
RUN gem install fpm
