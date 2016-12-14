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
                 dovecot passwd shadow-utils && \
    dnf -y clean all

MAINTAINER "Petr Hracek" <phracek@redhat.com>

ENV POSTFIX_SMTP_PORT=10025 POSTFIX_IMAP_PORT=10143 POSTFIX_SUBM_PORT=10587

ADD files /files

RUN /files/dovecot_config.sh

EXPOSE 10025
EXPOSE 10143
EXPOSE 10587

# Postfix UID based from Fedora
# USER 89

VOLUME ["/var/spool/postfix"]
VOLUME ["/var/spool/mail"]

CMD ["/files/start.sh"]
