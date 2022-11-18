V2Ray Base Image
=================

![GitHub Workflow Status](https://img.shields.io/github/workflow/status/chinayin-docker/v2ray/Docker%20Image%20CI)
![Docker Image Version (latest semver)](https://img.shields.io/docker/v/chinayin/v2ray?sort=semver)
![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/chinayin/v2ray?sort=semver)
![Docker Pulls](https://img.shields.io/docker/pulls/chinayin/v2ray)

A platform for building proxies to bypass network restrictions.

Using
------------

You can use the image directly, e.g.

```bash
docker run --rm -it chinayin/v2ray:bullseye
```

The images are built daily and have the security release enabled, so will contain any security updates released more
than 24 hours ago.

You can also use the images as a base for your own Dockerfile:

```bash
FROM chinayin/debian:bullseye
```
