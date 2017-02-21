# Composer Install

Wercker step to install composer dependencies. Includes a packaged version of
composer and caches for later user in `$WERCKER_CACHE_DIR`.

## Notes

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL
NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED",  "MAY", and
"OPTIONAL" in this document are to be interpreted as described in
RFC 2119.

## Sample Usage

    build:
      box: php:7.1
      steps:
        - bashaus/composer-install:
          dev: true

&nbsp;

## Dependencies

This step assumes that the box you are using already has PHP installed. Use
`box: php:7.1` or another container with PHP.

&nbsp;

## Step Properties

### clear-cache-on-failed

This script attempts to run `composer install` three times before failing.
After each failure, should the composer cache directory be cleared? Enable
with `true` or disable with `false`.

* Since: `0.0.1`
* Property is `Optional`
* Default value is: `true` (clear cache on failure)
* Recommended location: `Inline`
* `Validation` rules:
  * Must be either `true`, `false`, `1` or `0`

&nbsp;

### use-cache

To speed the installation process, composer uses a cache so that the package
doesn't need to be continuously downloaded. In this step, the cache is located
in `$WERCKER_CACHE_DIR/bashaus/composer-install` to persist across pipelines.
Enable persistent cache with `true` or disable with `false`.

* Since: `0.0.1`
* Property is `Optional`
* Default value is: `true` (use cache)
* Recommended location: `Inline`
* `Validation` rules:
  * Must be either `true`, `false`, `1` or `0`

&nbsp;

### dev

Whether to install development dependencies. By default, development
dependencies in `require-dev` are not installed during integration.
Enable `require-dev` with `true` or disable with `false`.

* Since: `0.0.1`
* Property is `Optional`
* Default value is: `false` (do not install from `require-dev`)
* Recommended location: `Inline`
* `Validation` rules:
  * Must be either `true`, `false`, `1` or `0`

&nbsp;

### opts

Any additional options and flags that you would like to pass to composer.

* Since: `0.0.1`
* Property is `Optional`
* Recommended location: `Inline`

&nbsp;
