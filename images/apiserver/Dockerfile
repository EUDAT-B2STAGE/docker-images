
FROM pdonorio/py3api
# FROM eudatb2safe/apiclient
MAINTAINER "Paolo D'Onorio De Meo <p.donoriodemeo@cineca.it>"

# # Install dependencies
# RUN apk add \
#     # needed by icommands
#     libfuse2 \
#     # requested for openssl in python
#     libffi-dev \
#     # globus and grid-ftp utils
#     globus-proxy-utils globus-simple-ca \
#     # CLEAN
#     && rm -rf /var/cache/apk/*

ENV GLOBUSFTP http://toolkit.globus.org/ftppub/gt6/installers
ENV GLOBUSGSIDEB $GLOBUSFTP/repo/globus-toolkit-repo_latest_all.deb

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y \
    # base utils
    nano vim \
    # needed by icommands
    libfuse2 \
    # requested for openssl in python
    libffi-dev \
    # globus and grid-ftp utils
    globus-proxy-utils globus-simple-ca \
    # proxy for certificates
    myproxy \
    # nginx for uwsgi
    nginx \
    # CLEAN
    && apt-get clean autoclean && apt-get autoremove -y && \
    rm -rf /var/lib/cache /var/lib/log

# ADD services which are not so common
RUN pip3 install --upgrade pip \
    # class as easy store of attributes
    attrs \
    # latest restful because the stable release is pretty outdated
    git+https://github.com/flask-restful/flask-restful@master \
    # authentication helpers
    pyopenssl flask-oauthlib \
    # necessary to use uwsgi
    uwsgi uwsgitop \
    # ADD extra services for other purpose
    https://github.com/mdantonio/PyVCF/archive/master.zip

###############################
# IRODS

# Environments
# ENV IRODS4VERSION 1.10
ENV IRODS4VERSION 1.8
ENV IRODSVERSION 4.$IRODS4VERSION
ENV OSVERSION ubuntu14
ENV IRODSFTP "ftp://ftp.renci.org/pub/irods"
ENV IRODSRELEASES "$IRODSFTP/releases/$IRODSVERSION/$OSVERSION"
ENV IRODSPKG "icommands"
ENV IRODSDEB $IRODSRELEASES/irods-${IRODSPKG}-${IRODSVERSION}-${OSVERSION}-x86_64.deb

# Icommands
WORKDIR /tmp

RUN wget -q $IRODSDEB \
    && dpkg -i irods*.deb \
    && rm *.deb
# # Example for environment
# http://j.mp/1RmGmWD

###############################
## Fix the gsi missing library.
# (Error: errno [] -- message [shared library does not exist [/var/lib/irods/plugins/auth/libgsi.so]])

# compatible with 4.1.8
ENV GSIVERSION 1.2
# # compatible with 4.1.10
# ENV GSIVERSION 1.4
ENV IRODSGSI "$IRODSFTP/plugins/irods_auth_plugin_gsi/$GSIVERSION"
# ENV SLIBS /sharedlibs
# RUN mkdir $SLIBS
RUN wget $IRODSGSI/irods-auth-plugin-gsi-${GSIVERSION}-${OSVERSION}-x86_64.deb \
    && ar vx irods-auth*.deb \
    && tar xf data.tar.xz -C / \
    && rm -rf *

###############################
## ADD USERS

# irods
ENV IRODS_USER irods
RUN useradd -ms /bin/bash $IRODS_USER
# guest for testing certificates
ENV GSI_USER guest
RUN useradd -ms /bin/bash $GSI_USER
# rodsminer for administration with GSI auth
ENV GSI_ADMIN rodsminer
RUN useradd -ms /bin/bash $GSI_ADMIN

###############################
## OTHERS SERVICES

# UWSGI
ENV UWSGI_LOGS /var/log/uwsgi
ENV UWSGI_RUN /var/run/uwsgi
RUN mkdir -p $UWSGI_LOGS
RUN mkdir -p $UWSGI_RUN
RUN chown -R www-data:www-data $UWSGI_LOGS $UWSGI_RUN
ADD init.sh /usr/sbin/init
# CMD ["/usr/sbin/init"]
CMD ["sleep", "infinity"]

###############################
# Go online as the same irods user
RUN echo "echo '\nRun Flask server with the command:'\necho '$ ./boot devel'\necho ''\necho 'Run tests with $ nose2 -F [test.FOLDER]'\n" \
    >> /home/$IRODS_USER/.bashrc
USER $IRODS_USER
