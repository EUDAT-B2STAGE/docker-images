
FROM alpine:edge
# Note:
# This is image is intended to be as small as possible
MAINTAINER "Paolo D'Onorio De Meo <p.donoriodemeo@cineca.it>"

RUN apk update && apk upgrade && apk add \
    python3 jq\
    bash vim curl wget less \
    && rm -rf /var/cache/apk/*

# Install easy install
ENV EASY_REPO https://bootstrap.pypa.io/ez_setup.py
RUN curl $EASY_REPO | python3

# Install pip and pip packages
RUN easy_install pip \
    && pip --no-cache-dir install --upgrade \
    pip httpie http-prompt

# Create a token from API
ADD client_init.sh /tmp/gettoken

# Handle a guest user
ENV GUEST_SHELL /bin/bash
ENV GUEST_USER developer
ENV GUEST_UID 1000
RUN adduser -s $GUEST_SHELL -u $GUEST_UID -D -h /home/$GUEST_USER $GUEST_USER

# Use the new user
USER $GUEST_USER
ENV BASHRC /home/$GUEST_USER/.bashrc
RUN echo "export HISTCONTROL=ignoreboth:erasedups" > $BASHRC \
    && echo "echo -e '\\nSet up this client with the command:'" >> $BASHRC \
    && echo "echo -e '$ . /tmp/gettoken\\n'" >> $BASHRC
ENV PAGER less
ENV TERM xterm
