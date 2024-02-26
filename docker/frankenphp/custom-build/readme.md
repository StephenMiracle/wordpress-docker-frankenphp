# WordPress FrankenPHP Custom Docker Build

**_Disclaimer: This is a project in testing. Do not use in any active projects. Feel free to contribute and add._**

## Objective: Build a WordPress Docker Image using a custom FrankenPHP build

This project was started to track building a WordPress Docker image with a custom FrankenPHP build. I noticed that the standard build of FrankenPHP was performing worse than the standard WordPress image with Apache in loader.io tests. I hypothesized that this is due to http caching which requires a custom FrankenPHP build & Caddyfile modifications.

### Where things stand: Not working

Currently, I am unable to build & run a custom FrankenPHP image in a Windows / Linux x86 environment. It does build inside of an Linux ARM instance. But, it still fails to run as expected.

When loading on the browser, it just idles out without returning a response. I was able to track down that at least one of the issues is in the Wordpress wp-includes/default-filters.php file. Whenever you try to add_filter related to formatting.php. This appears odd because it doesn't occur in the standard build. I assume it is some PHP functionality that FrankenPHP is unable to resolve in the custom build.
