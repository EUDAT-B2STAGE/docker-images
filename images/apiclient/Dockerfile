# Note:
# This is image is intended to be as small as possible

FROM alpine
MAINTAINER "Paolo D'Onorio De Meo <p.donoriodemeo@cineca.it>"

RUN apk update && apk upgrade && apk add \
    python3 \
    curl wget less \
    && rm -rf /var/cache/apk/*

# Install easy install
ENV EASY_REPO https://bootstrap.pypa.io/ez_setup.py
RUN wget $EASY_REPO --no-check-certificate -O - | python3

# Install pip and pip packages
RUN easy_install pip \
    && pip --no-cache-dir install --upgrade \
    httpie http-prompt

ENV PAGER less
ENV TERM xterm
