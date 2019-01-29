#!/bin/sh

echo $1

echo "----"

case $1 in
  add_user)
    echo "Creating user '$2'..."
    adduser -D "$2"
    echo "$2:$3" | chpasswd
    echo -e "$3\n$3" | (smbpasswd -a -s "$2")
  ;;
  add_group)
    echo "Creating group '$2'..."
    groupadd "$2"
  ;;
  add_user_to_group)
    echo "Adding user '$2' to group '$3'..."
    usermod -a -G "$3" "$2"
  ;;
  delete_user)
    echo "Removing user '$2'..."
    deluser --remove-home "$2"
  ;;
  password)
    echo "Changing password of user '$2'..."
    echo "$2:$3" | chpasswd
    echo -e "$3\n$3" | (smbpasswd -a -s "$2")
  ;;
  rclone)
    echo "Add rclone Google G Suite Team Drive share '$2'..."
    rclone config create "$2" drive \
        client_id "$3" \
        client_secret "$4" \
        scope drive \
        team_drive "$5"
    rclone config create "$2cache" cache \
        type cache \
        remote "$2": \
        chunk_size 10M \
        info_age 10m \
        chunk_total_size 10G \
        db_purge false \
        chunk_clean_interval 1h \
        read_retries 5 \
        workers 4 \
        chunk_no_memory true \
        writes true \
        tmp_wait_time 1h \
        db_wait_time 0
    mkdir "/mnt/$2"
    rclone -v --log-file=/dev/stdout \
            mount \
            --vfs-cache-mode writes \
            --umask 000 \
            --allow-other \
            --dir-cache-time=5m \
            "$2cache": "/mnt/$2"
    echo "[$2]" >> /etc/samba/smb.conf
    echo "  path = /media/$2" >> /etc/samba/smb.conf
    echo "  browsable = yes" >> /etc/samba/smb.conf
    echo "  writable = yes" >> /etc/samba/smb.conf
    echo "  read only = no" >> /etc/samba/smb.conf
    echo "  guest ok = yes" >> /etc/samba/smb.conf
    killall -SIGTERM smbd
    /usr/sbin/smbd -s /etc/samba/smb.conf
  ;;
  *)
    echo "Login/fileserver management utility"
    echo "---------------------------------------"
    echo
    echo "Usage:"
    echo
    echo "manage add_user [USERNAME] [PASSWORD]"
    echo "  Adds a new user."
    echo
    echo "manage add_group [GROUPNAME]"
    echo "  Adds a new group."
    echo
    echo "manage add_user_to_group [USERNAME] [GROUPNAME]"
    echo "  Adds a user to a group."
    echo
    echo "manage delete_user [USERNAME]"
    echo "  Remove a user."
    echo
    echo "manage password [USERNAME] [PASSWORD]"
    echo "  Reset a user password."
    echo
    echo "manage rclone [NAME] [GOOGLE_CLIENT_ID] [GOOGLE_CLIENT_SECRET] [TEAM_DRIVE_ID]"
    echo "  Add Google Team Drive Rclone, Samba and mount"
esac
