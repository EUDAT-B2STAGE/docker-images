##########################################################################
FROM ubuntu:14.04
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
RUN echo "install libs" && \
    wget -q $GLOBUSGSIDEB && dpkg -i globus-*repo*.deb && \
    apt-get update -qq && \
    apt-get install -y \
    # development of GSI build
    build-essential telnet locate apt-file \
    libssl-dev libglobus-gssapi-gsi4 libglobus-gssapi-gsi-dev \
    # base libs
    libfuse2 libjson-perl \
    # db
    unixodbc odbc-postgresql postgresql-client super \
    # python
    python python-psutil python-requests python-jsonschema \
    # gsi irods plugin dependencies
    libglobus-gssapi-gsi4 libglobus-gss-assist3 \
    # globus and proxy
    globus-proxy-utils globus-gsi-cert-utils-progs globus-simple-ca \
    # CLEAN
    && apt-get clean autoclean && apt-get autoremove -y && \
    rm -rf /var/lib/cache /var/lib/log
    # /var/lib/apt /var/lib/dpkg

##########################################################################
# IRODS icat server
# install instructions: https://docs.irods.org/4.1.10/manual/installation
RUN mkdir irods-packages
WORKDIR /tmp/packages
ENV IRODS4V 1.10
ENV IRODSV 4.$IRODS4V
ENV OSV ubuntu14
ENV IRODSFTP "ftp://ftp.renci.org/pub/irods"
ENV IRODSREL "$IRODSFTP/releases/$IRODSV/$OSV"
ENV GSIV 1.4
ENV IRODSGSI "$IRODSFTP/plugins/irods_auth_plugin_gsi/${GSIV}"
ENV GSIDEB /tmp/gsi.deb

RUN wget -q \
     $IRODSREL/irods-icat-${IRODSV}-${OSV}-x86_64.deb \
    && wget -q $IRODSREL/irods-dev-${IRODSV}-${OSV}-x86_64.deb \
    && wget -q $IRODSREL/irods-runtime-${IRODSV}-${OSV}-x86_64.deb \
    && wget -q \
     $IRODSREL/irods-database-plugin-postgres-${IRODS4V}-${OSV}-x86_64.deb \
    # && wget -q \
    #  $IRODSGSI/irods-auth-plugin-gsi-${GSIV}-${OSV}-x86_64.deb \
    #  #-O $GSIDEB \
    && echo "Downloaded" \
# Install irods packages
    && dpkg -i irods-icat* irods-dev* irods-runtime* irods-database* \
    && rm -rf *.deb

# Remove irods remote validation
RUN sed -i '36s/https[^\"]\+/off/' /etc/irods/server_config.json
WORKDIR /tmp

##########################################################################
# install scripts: to be executed only the first time
ADD expect_irods.sh /tmp/expect_irods
ADD install_irods.sh /init
# normal boot up script
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

# guest for testing certificates
ENV GSI_USER guest
RUN useradd -ms /bin/bash $GSI_USER
# rodsminer for administration with GSI auth
ENV GSI_ADMIN rodsminer
RUN useradd -ms /bin/bash $GSI_ADMIN

##########################################################################
# THE INIT PHASE IS NECESSARY OUTSIDE OF THE DOCKERFILE
#
# How to:
# Install irods + connect to postgres.
# Then run the following setup script:
# $ sudo /var/lib/irods/packaging/setup_irods.sh

##########################################################################
# Saving configurations files/passw/environments
# for persistence on irods modifications
VOLUME /etc
# VOLUME /etc/irods
# VOLUME /etc/grid-security

##########################################################################
## Closing operations

# add environment for guest
WORKDIR /home/$GSI_USER
ADD guest.irods.env.json .irods/irods_environment.json
RUN chown -R $GSI_USER:$GSI_USER /home/$GSI_USER/.irods

# passwd handling
ADD handlepassw.sh /pass

# irods user setup
ENV IRODS_HOST rodserver
ADD certificates_init.sh /init_certificates
EXPOSE 1247

# Various
ENV TERM xterm
# if you need to add future commands after irods installation,
# use the following
ENV EXTRA_INSTALLATION_SCRIPT /extras
# volumes
VOLUME /home/$IRODS_USER
VOLUME /var/lib/$IRODS_USER

# Become irods main user
USER $IRODS_USER
WORKDIR /home/$IRODS_USER

ADD new_authority.sh /addusercert
