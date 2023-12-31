FROM ubuntu:focal

# To build this, from this directory, run
#   docker build -t ghcr.io/nebulaclouds/nebulaportal:v0.42.0 -f Dockerfile .

WORKDIR /root
ENV VENV /root/venv
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONPATH /root

RUN : \
    && apt-get update \
    && apt-get install -y make build-essential libssl-dev \
    && apt-get install -y curl wget vim

RUN : \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y dnsutils htop

RUN : \
    && apt-get update && apt-get install -y python3.8 python3.8-venv python3.8-dev python3-pip cython3

RUN pip3 install awscli

WORKDIR /setup/redis
RUN wget http://download.redis.io/redis-stable.tar.gz \
    && tar xvzf redis-stable.tar.gz \
    && cd redis-stable \
    && make \
    && cp src/redis-cli /usr/local/bin/

RUN apt-get install -y postgresql-client

# Virtual environment
RUN python3.8 -m venv ${VENV}
RUN ${VENV}/bin/pip install wheel

# Install Python dependencies
RUN ${VENV}/bin/pip install ipdb
RUN ${VENV}/bin/pip install pyarrow
RUN ${VENV}/bin/pip install nebulakit

# This is a script that enables a virtualenv, copy it to a better location
RUN cp ${VENV}/bin/nebulakit_venv /opt/
RUN chmod a+x /opt/nebulakit_venv

COPY .bash_aliases /root/
COPY .bashrc /root
COPY motd /etc
RUN chmod a+r /etc/motd

WORKDIR /root
