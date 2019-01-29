FROM alpine:latest
MAINTAINER Johan Els <johan@who-els.co.za>

WORKDIR /

RUN apk update && \
    apk upgrade

# Install SAMBA
RUN apk add --no-cache samba-common-tools samba-client samba
# Install NETATALK
RUN apk add --no-cache netatalk
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
ADD scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
ADD scripts/manage.sh /usr/local/bin/manage.sh

# Defibe entry point and run it
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD /usr/local/bin/entrypoint.sh
