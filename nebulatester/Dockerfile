FROM ubuntu:focal

WORKDIR /root
ENV VENV /root/venv
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONPATH /root

RUN : \
    && apt-get update \
    && apt install -y software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa

RUN : \
    && apt-get update \
    && apt-get install -y python3.8 python3-pip python3-venv make build-essential libssl-dev curl vim jq

# This is necessary for opencv to work
RUN apt-get update && apt-get install -y libsm6 libxext6 libxrender-dev ffmpeg

# Install the AWS cli separately to prevent issues with boto being written over
RUN pip3 install awscli

# Install gcloud for GCP
RUN curl -sSL https://sdk.cloud.google.com | bash
ENV PATH="$PATH:/root/google-cloud-sdk/bin"

# Virtual environment
RUN python3.8 -m venv ${VENV}
RUN ${VENV}/bin/pip install wheel

# Install Python dependencies
COPY ./requirements.txt /root
RUN ${VENV}/bin/pip install -r /root/requirements.txt

RUN mkdir /opt/go
# This will be removed once nebulactl respects command line settings
COPY ./end2end/config.yaml /opt/go
WORKDIR /opt/go
RUN curl -s https://raw.githubusercontent.com/nebulaclouds/nebulactl/master/install.sh | bash
ENV PATH="/opt/go/bin:$PATH"
WORKDIR /root

COPY . /root

RUN cp ${VENV}/bin/nebulakit_venv /usr/local/bin/nebulakit_venv
RUN chmod a+x /usr/local/bin/nebulakit_venv

ARG DOCKER_IMAGE

# Environment variables we want to bake into the image
# These are configuration options that can also be specified in a file.  See nebulakit.config as an examples

# This tag is supplied by the build script and will be used to determine the version
# when registering tasks, workflows, and launch plans
ENV NEBULA_INTERNAL_IMAGE "$DOCKER_IMAGE"
