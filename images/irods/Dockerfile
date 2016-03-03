##########################################################################
FROM ubuntu:15.10
MAINTAINER "Paolo D'Onorio De Meo <p.donoriodemeo@cineca.it>"

##########################################################################
# Base setup and Install dependencies
ENV DEBIAN_FRONTEND "noninteractive"

# Use apt to install base applications
RUN apt-get update -qq && \
    apt-get install -y \
    # base utils
    wget git expect lsof sudo nano vim \
    # CLEAN \
    && apt-get clean autoclean && apt-get autoremove -y && \
    rm -rf /var/lib/cache /var/lib/log

# Add all of the irods/globus/gsi dependencies
ENV GLOBUSFTP http://toolkit.globus.org/ftppub/gt6/installers
ENV GLOBUSGSIDEB $GLOBUSFTP/repo/globus-toolkit-repo_latest_all.deb
RUN wget -q $GLOBUSGSIDEB && dpkg -i globus-*repo*.deb && \
    apt-get update -qq && \
    apt-get install -y \
    # base libs
    libfuse2 libjson-perl \
    # db
    unixodbc odbc-postgresql postgresql-client super \
    # python
    python python-psutil python-requests python-jsonschema \
    # gsi irods plugin dependencies
    libglobus-gssapi-gsi4 libglobus-gss-assist3 \
    # globus and proxy
    globus-proxy-utils globus-simple-ca \
#    globus-gsi globus-gridftp globus-gsi-cert-utils-progs \
    # CLEAN \
    && apt-get clean autoclean && apt-get autoremove -y && \
    rm -rf /var/lib/cache /var/lib/log
    # /var/lib/apt /var/lib/dpkg

##########################################################################
# IRODS icat server
# install instructions: https://docs.irods.org/4.1.5/manual/installation
WORKDIR /tmp
ENV IRODSVERSION 4.1.8
ENV IRODSFTP "ftp://ftp.renci.org/pub/irods"
ENV IRODSRELEASES "$IRODSFTP/releases/$IRODSVERSION/ubuntu14"
RUN wget -q $IRODSRELEASES/irods-icat-${IRODSVERSION}-ubuntu14-x86_64.deb
RUN wget -q $IRODSRELEASES/irods-database-plugin-postgres-1.8-ubuntu14-x86_64.deb
ENV IRODSGSI "$IRODSFTP/plugins/irods_auth_plugin_gsi/1.2"
ENV IRODSGSI_DEB /opt/gsi.deb
RUN wget -q $IRODSGSI/irods-auth-plugin-gsi-1.2-ubuntu14-x86_64.deb -O $IRODSGSI_DEB


##########################################################################
# install scripts
ADD expect_irods.sh /tmp/expect_irods
ADD install_irods.sh /install
# boot up script
ADD bootstrap.sh /bootup
CMD ["/bootup"]

##########################################################################
# A default system PostgreSQL installation is configured for ident-based auth
# means the unix service account name must match the database user name
ENV IRODS_USER "irods"
ENV IRODS_PASS "icatserver"
RUN useradd -ms /bin/bash $IRODS_USER
RUN yes $IRODS_PASS | passwd $IRODS_USER
RUN adduser $IRODS_USER sudo
USER $IRODS_USER

##########################################################################

# Install irods packages
RUN yes $IRODS_PASS | sudo -S dpkg -i irods*.deb

# Saving configuration files for persistence on irods modifications
VOLUME /etc/irods

## The bad hack. Change it in future docker releases,
## when volumes mapping would probably be available and easy
#RUN mkdir copy && rsync -av /etc/irods/ copy/etcirods/
### IMPORTANT
# Must check if this above can be changed/removed now
### IMPORTANT

###############################
## Very important docker hack
# Ensure that irods user certificates can be shared as a volume
VOLUME /home/$IRODS_USER
RUN yes $IRODS_PASS | sudo -S chown -R $IRODS_USER:$IRODS_USER /home/$IRODS_USER
###############################

##########################################################################
# THE INIT PHASE IS NECESSARY OUTSIDE OF THE DOCKERFILE
#
# How to do it?
# Install irods + connect to postgres. Then run the following setup script:
#   sudo /var/lib/irods/packaging/setup_irods.sh

##########################################################################
# Should it also create a resource Server ?
# https://docs.irods.org/4.1.5/manual/installation/#resource-server

# ##########################################################################
# # # install simple CA
# # RUN echo -e "$GSI_NEWUSER_NAME" | grid-cert-request -nopw
# # RUN yes | sudo grid-ca-sign -in /home/$IRODS_USER/.globus/usercert_request.pem -out /home/$IRODS_USER/.globus/usercert.pem

##########################################################################
# Closing operations
ENV TERM xterm
WORKDIR /home/$IRODS_USER
EXPOSE 1247
ENV IRODS_HOST rodserver

# if you need to add future commands after irods installation,
# use the following
ENV EXTRA_INSTALLATION_SCRIPT /extras
