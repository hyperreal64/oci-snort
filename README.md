# oci-snort

This is a container image for running Snort via Podman or Docker. I've only tested it with Podman version 2.2.1 and Snort version 2.9.17.

The entrypoint.sh script adds necessary post-installation changes to `/etc/pulledpork/pulledpork.conf` and `/etc/snort/snort.conf`. Feel free to make your own changes to these files as you see fit.

Immutable [libostree](https://ostreedev.github.io/ostree/)-based distributions like Fedora CoreOS and Silverblue require the container to be run with root privileges in order to access network interfaces.

To run the container, use the following commands:

For log files:
```bash
mkdir ~/snort_logs
```

Distributions using SELinux require the following SELinux context set on `${HOME}/snort_logs`:
```bash
chcon -Rt svirt_sandbox_file_t ~/snort_logs
```

`podman` and `docker` commands are nearly identical in the arguments and flags they accept, so Docker users can simply replace `podman` with `docker` below:
```bash
podman run -it --name snort \
    -v "${HOME}/snort_logs:/var/log/snort" \
    -e HOME_NET="<your CIDR here>" \
    -e OINKCODE="<your oinkcode here>" \
    --network host \
    --cap-add=NET_ADMIN \
    --cap-add=NET_RAW \
    --restart always \
    hyperreal/snort:latest
```
