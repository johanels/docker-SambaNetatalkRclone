#!/bin/sh

INITALIZED="/.initialized"

# First time initialisation
if [ ! -f "$INITALIZED" ]; then
  echo ">> CONTAINER: starting initialisation"

  # SAMBA Configuration
  ##
  cat > /etc/samba/smb.conf <<EOF
[global]
    workgroup = WORKGROUP
    server string = %h server (Samba, Alpine)
    security = user
    map to guest = Bad User
    encrypt passwords = yes
    load printers = no
    printing = bsd
    printcap name = /dev/null
    disable spoolss = yes
    disable netbios = no
    server role = standalone
    server services = -dns, -nbt
    smb ports = 445
    ;name resolve order = hosts
    ;log level = 3
    log file = /dev/stdout
    create mask = 0664
    directory mask = 0775
    veto files = /.DS_Store/
    nt acl support = no
    inherit acls = yes
    ea support = yes
    vfs objects = catia fruit streams_xattr recycle
    acl_xattr:ignore system acls = yes
    recycle:repository = .recycle
    recycle:keeptree = yes
    recycle:versions = yes
[homes]
    comment = Home Directories
    browseable = yes
    read only = no
    create mask = 0700
    directory mask = 0700
    valid users = %S
    read only = no
EOF

  # AFP setup
  echo ">> AFPD CONFIG:"
  cat > /etc/afp.conf <<EOF
[Global]
  hostname = UltimateSamba
  zeroconf = yes
  log file = /dev/stdout
  cnid scheme = dbd
  uam list = uams_dhx2.so
  save password = yes
  spotlight = yes
  dbus daemon = /usr/bin/dbus-daemon
[Homes]
  path = afp-data
  basedir regex = /home
EOF

  # Set as initialized
  touch "$INITALIZED"
else
  echo ">> CONTAINER: already initialized"
  echo ">> STARTING SERVICES"
  /usr/sbin/smbd -s /etc/samba/smb.conf
  /usr/sbin/netatalk -F /etc/afp.conf
fi

exec "$@"
