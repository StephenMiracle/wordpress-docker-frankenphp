# Enterprise-Grade WordPress Images Ready to Go

An enterprise-grade WordPress image built for scalability. It uses the new FrankenPHP App Server with PHP-FRM built-in. Popular caching extensions included (Redis, Memcached, opcache). It also runs on a non-root www-data user for modern security. Composer is also included if desired to add dependencies & run scripts via an extended image.

The goal for this WordPress Docker image repository is to include everything needed for the majority of the use cases. You can deploy your WordPress projects directly from this image or use it as a starter for a custom image.

## Whats Included

### Services

- [WordPress](https://hub.docker.com/_/wordpress "WordPress Docker Image")
- [FrankenPHP](https://hub.docker.com/r/dunglas/frankenphp "FrankenPHP Docker Image")
- [PHP-FPM](https://hub.docker.com/_/wordpress "WordPress Docker Image")
- [Composer](https://hub.docker.com/_/composer "Composer Docker Image")

### Caching Extensions Installed

- redis
- memcached
- opcached

### Environment Variables

- DEBUG // Flag to set WP_DEBUG & debug mode on server. (1 or 0)
- SERVER_NAME // Domain to set. Will request a SSL cert for it.
- WP
- DB_NAME
- DB_USER
- DB_PASSWORD
- DB_HOST
- DB_ROOT_PASSWORD
- DB_TABLE_PREFIX
- WP_DEBUG
- WP_VERSION

### Open Ports

- 80 //Set http traffic from "server_name" env variable to point here.
- 443 //Set https traffic from "server_name" env variable to point to here.
- 8095 //Use this port when its behind a reverse proxy (load balancers, Kubernetes, other container orchestrations. Probably many use cases.)

This image copies content from the base WordPress image. Relevant environment variables can be found in the parent repository.

[Click here for the standard WordPress Docker Repo.](https://hub.docker.com/_/wordpress "WordPress Docker Images")

## Questions

### Why Not Just Use Standard WordPress Images?

The standard WordPress images are a good starting point and can handle many use cases, but they don't include caching extensions or Composer. You also don't get FrankenPHP app server. Instead, you need to choose Apache or PHP-FPM. We use the WordPress base image but extend it.

### Why FrankenPHP?

Do you want to use PHP-FPM with Wordpress & Apache? Not easy. Now you need 2 Docker images & deploying just got that much harder. FrankenPHP is built on Caddy, a modern web server. It is secure & performs well when scaling becomes important. It also allows us to integrate PHP-FPM into a single Docker image! Opens up whole new world.

**[Check out FrankenPHP Here](https://frankenphp.dev/ "FrankenPHP")**

### Why is Non-Root User Important?

It is good practice to avoid using root users in your Docker images for security purposes. If a questionable individual gets access into your running Docker container with root account then they could have access to the cluster and all the resources it manages. This could be problematic. On the other hand, by creating a user specific to the Docker image, narrows the threat to only the image itself. It is also important to note that the base WordPress images also create non-root users by default.

### Why Include Redis, Memcached & Composer?

Convenience with low impact on final size. You may or may not use one of these services, but it is convenient to have them available when needed. It helps to not have to extend and create new Docker images for single services.

### What are the Changes from Base FrankenPHP?

This Docker image has a custom Caddyfile that has slight modifications from the FrankenPHP base image. The auto http to https redirects are turned off. In addition, it allows for all hosts on port 8095. This is needed for cloud services such as Kubernetes, ECS & Load Balancers where the request host is reversed proxied and unknown.

### How to use in AWS & Other Cloud Providers?

The server_name environment variable won't be useful in these scenarios as it is behind a reverse proxy like a load balancer. You will need to map PORT 80 traffic to PORT 8095. Listen on PORT 80 and then target PORT 8095 (ie 80:8095 in docker-compose.yml)
