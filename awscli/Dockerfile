FROM debian:9.5
LABEL maintainer="hkbwt.code@gmail.com"

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y build-essential \
    && apt-get install -y software-properties-common \
    && apt-get install -y byobu curl git htop man unzip vim wget python3 \
    &&  rm -rf /var/lib/apt/lists/*

RUN curl -O https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py \
    && pip install awscli

RUN mkdir /build
WORKDIR /build

CMD ["aws"]