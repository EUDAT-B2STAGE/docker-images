
FROM pdonorio/py3api
MAINTAINER "Paolo D'Onorio De Meo <p.donoriodemeo@gmail.it>"

ENV GLOBUSFTP http://toolkit.globus.org/ftppub/gt6/installers
ENV GLOBUSGSIDEB $GLOBUSFTP/repo/globus-toolkit-repo_latest_all.deb

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y \
    # base utils
    nano vim \
    # needed by icommands
    libfuse2 \
    # globus and grid-ftp utils
    globus-proxy-utils globus-simple-ca \
    # CLEAN \
    && apt-get clean autoclean && apt-get autoremove -y && \
    rm -rf /var/lib/cache /var/lib/log

# ADD services which are not so common

###############################
# IRODS

# Environments
ENV IRODSVERSION 4.1.8
ENV IRODSFTP "ftp://ftp.renci.org/pub/irods/releases/$IRODSVERSION/ubuntu14"
ENV IRODSPKG "icommands"
ENV IRODSDEB $IRODSFTP/irods-${IRODSPKG}-${IRODSVERSION}-ubuntu14-x86_64.deb

# Icommands
WORKDIR /tmp

RUN wget -q $IRODSDEB \
    && dpkg -i irods*.deb \
    && rm *.deb
# # Example for environment
# http://j.mp/1RmGmWD

###############################
## ADD USERS

# irods
ENV IRODS_USER irods
RUN useradd -ms /bin/bash $IRODS_USER
# guest for testing certificates
ENV GSI_USER guest
RUN useradd -ms /bin/bash $GSI_USER

###############################
## OTHERS SERVICES?

# empty for now

###############################
RUN echo "echo 'Run Flask server with the command:'" >> /root/.bashrc
RUN echo "echo './boot devel'" >> /root/.bashrc
