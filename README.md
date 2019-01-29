Docker Samba, NetTalk and Rclone

Build a Docker image based from Alpine Linux and inject rclone.

The idea is to start a SMB/AFP server with cache rclone Cloud storage mounts.

```bash
docker build . -t ultimate
docker run \
  --name ultimate \
  -it \
  -p 139:139 \
  -p 445:445 \
  -p 548:548 \
  -p 5353:5353 \
  ultimate ash
```
