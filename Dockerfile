FROM fedora:24

# Postfix image for OpenShift.
#
# Volumes:
#  * /var/spool/postfix -
#  * /var/spool/mail -
#  * /var/log/postfix - Postfix log directory
# Environment:
#  * $MYHOSTNAME - Hostname for Postfix image
# Additional packages
#  * findutils are needed in case fedora:24 is loaded from docker.io.

RUN dnf install -y --setopt=tsflags=nodocs \
                 findutils openssl-libs \
                 dovecot postfix passwd shadow-utils && \
    dnf -y clean all

MAINTAINER "Petr Hracek" <phracek@redhat.com>

ADD files /files

RUN /files/dovecot_config.sh

# Postfix UID based from Fedora
# USER 89

VOLUME ["/var/spool/postfix"]
VOLUME ["/var/spool/mail"]

CMD ["/files/start.sh"]
