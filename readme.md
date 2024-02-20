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

## Additional References

- **Repository Source:**
  https://github.com/wpatscale/wordpress-docker
- **Submit Issue / Change Request:**
  https://github.com/wpatscale/wordpress-docker/issues
- **Visit Our Home**
  https://WPatScale.com
