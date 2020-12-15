# oci-snort

This is a container image for running Snort via Podman or Docker. I've only tested it with Podman version 2.2.1 and Snort version 2.9.17.

The `entrypoint.sh` script adds necessary post-installation changes to `/etc/pulledpork/pulledpork.conf` and `/etc/snort/snort.conf`:
* `snort.conf`: setting the paths to Fedora-friendly values
* `snort.conf`: setting the `var WHITE_LIST_PATH` and `var BLACK_LIST_PATH` values to `rules` because there is a bug in Snort that causes the relative path `../rules` to be expanded incorrectly.
* `snort.conf`: commenting out individual rule files that are enabled in the vanilla snort.conf. The reason for this is convenience, as PulledPork by default downloads rules and saves them to a file named `/etc/snort/rules/snort.rules`.
* `pulledpork.conf`: the value of the OINKCODE environment variable replaces the text in the appropriate spot.

> Immutable [libostree](https://ostreedev.github.io/ostree/)-based distributions like Fedora CoreOS and Silverblue require the container to be run with root privileges in order to access network interfaces.

To run the container, use the following commands:

For log files:
```bash
mkdir ~/snort_logs
```

`podman` and `docker` commands are nearly identical in the arguments and flags they accept, so Docker users can simply replace `podman` with `docker` below:
```bash
podman run -it --rm --name snort -v ${HOME}/snort_logs:/var/log/snort -v /etc/localtime:/etc/localtime:ro -e HOME_NET="<your CIDR here>" -e OINKCODE="<your oinkcode here>" --network host --cap-add=NET_ADMIN --cap-add=NET_RAW --restart always hyperreal/snort:latest
```

Distributions using SELinux require the following SELinux context set on `${HOME}/snort_logs`:
```bash
chcon -Rt svirt_sandbox_file_t ~/snort_logs
```
