ARG DOCKER_IMAGE_BASE=ubuntu:focal

FROM ${DOCKER_IMAGE_BASE}

ARG FPM_VERSION=1.9.3

RUN apt-get update && \
   apt-get -qy install python3-dev python3-pip python3-virtualenv apt-transport-https curl gnupg ruby rubygems-integration ruby-dev build-essential rsync && \
   apt-get -qy upgrade && \
   apt-get autoremove && \
   apt-get clean

RUN python3 -m pip install virtualenv-tools
RUN gem install fpm --version ${FPM_VERSION}
RUN groupadd --gid 1000 builders \
  && useradd --uid 1000 --gid builders --shell /bin/sh --create-home builder
RUN mkdir -p /app/src && mkdir -p /app/out && chown -R builder:builders /app

WORKDIR /app
