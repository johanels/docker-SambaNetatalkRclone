FROM alpine:latest
MAINTAINER Johan Els <johan@who-els.co.za>

WORKDIR /

RUN apk update && \
    apk upgrade

# Install supervisor services
RUN apk add --no-cache supervisor
ADD configs/supervisord.conf /etc/supervisord.conf

# Install AVAHI mDNS/DNS-SD protocol suite
RUN apk add --no-cache avahi
ADD configs/avahi-daemon.conf /etc/avahi/avahi-daemon.conf
EXPOSE 5353/udp

# Install SAMBA
RUN apk add --no-cache samba-common-tools samba-client samba
ADD configs/smb.conf /etc/samba/smb.conf
EXPOSE 137/udp 138/udp 139 445

# Install NETATALK
RUN apk add --no-cache netatalk
ADD configs/afp.conf /etc/afp.conf
EXPOSE 548

# Install RCLONE
RUN apk add --no-cache curl unzip
RUN curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip && \
    unzip rclone-current-linux-amd64.zip && \
    cd rclone-*-linux-amd64 && \
    cp rclone /usr/bin/ && \
    chmod 755 /usr/bin/rclone && \
    rm -rf rclone-current-linux-amd64.zip rclone-*-linux-amd64

# Clean cache
RUN rm -rf /var/cache/apk/*

# Add local script files
#ADD scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
#ADD scripts/manage.sh /usr/local/bin/manage.sh

# Define entrypoint
#ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
#CMD /usr/local/bin/entrypoint.sh

# Another entrypoint
#ENTRYPOINT ["smbd", "--foreground", "--log-stdout"]
#CMD []

ENTRYPOINT ["supervisord", "-c", "/etc/supervisord.conf"]

CMD []
