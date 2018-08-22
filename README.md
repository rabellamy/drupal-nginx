# Drupal Nginx

This project assumes the below directory structure where the `docker` directory
contains the contents of `drupal-nginx`.

```bash
.
├── README.md
├── composer.json
├── composer.lock
├── config
├── docker
├── kubernetes
├── scripts
├── vendor
└── src
```

To build the Dockerfile from the root of your Drupal project run:

```bash
docker build -t [repository]/[name]:[tag] -f docker/Dockerfile .
```
