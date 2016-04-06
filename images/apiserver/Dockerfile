
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
ENV IRODSFTP "ftp://ftp.renci.org/pub/irods"
ENV IRODSRELEASES "$IRODSFTP/releases/$IRODSVERSION/ubuntu14"
ENV IRODSPKG "icommands"
ENV IRODSDEB $IRODSRELEASES/irods-${IRODSPKG}-${IRODSVERSION}-ubuntu14-x86_64.deb

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

ENV GSIVERSION "1.2"
ENV IRODSGSI "$IRODSFTP/plugins/irods_auth_plugin_gsi/$GSIVERSION"
# ENV SLIBS /sharedlibs
# RUN mkdir $SLIBS
RUN wget $IRODSGSI/irods-auth-plugin-gsi-${GSIVERSION}-ubuntu14-x86_64.deb \
    && ar vx irods-auth*.deb \
    && tar xf data.tar.xz -C / \
    && rm -rf *

## A PAST SOLUTION
# # Use ldconfig to apply this lib to the system
# #http://codeyarns.com/2014/01/14/how-to-add-library-directory-to-ldconfig-cache/

# RUN echo "# irods gsi libs\n$SLIBS/var/lib/irods/plugins/auth" \
#     > /etc/ld.so.conf.d/irods.conf \
#     && /sbin/ldconfig

###############################
## ADD USERS

# irods
ENV IRODS_USER irods
RUN useradd -ms /bin/bash $IRODS_USER
# guest for testing certificates
ENV GSI_USER guest
RUN useradd -ms /bin/bash $GSI_USER

###############################
## OTHERS SERVICES

# Nose for tests
pip install --upgrade nose

###############################
# Go online as the same irods user
RUN echo "echo 'Run Flask server with the command:'\necho './boot devel'" \
    >> /home/$IRODS_USER/.bashrc
USER $IRODS_USER
