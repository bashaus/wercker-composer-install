#!/bin/bash

# Property: clear-cache-on-failed
# Must be a valid boolean (true, false, 1 or 0)
case "$WERCKER_COMPOSER_INSTALL_CLEAR_CACHE_ON_FAILED" in
  "true" | "1" ) WERCKER_COMPOSER_INSTALL_CLEAR_CACHE_ON_FAILED=1 ;;
  "false" | "0" ) WERCKER_COMPOSER_INSTALL_CLEAR_CACHE_ON_FAILED=0 ;;
  * ) fail "Property clear-cache-on-failed must be either true or false"
esac

# Property: use-cache
# Must be a valid boolean (true, false, 1 or 0)
case "$WERCKER_COMPOSER_INSTALL_USE_CACHE" in
  "true" | "1" ) WERCKER_COMPOSER_INSTALL_USE_CACHE=1 ;;
  "false" | "0" ) WERCKER_COMPOSER_INSTALL_USE_CACHE=0 ;;
  * ) fail "Property use-cache must be either true or false"
esac

# Property: dev
# Must be a valid boolean (true, false, 1 or 0)
case "$WERCKER_COMPOSER_INSTALL_DEV" in
  "true" | "1" ) WERCKER_COMPOSER_INSTALL_DEV=1 ;;
  "false" | "0" ) WERCKER_COMPOSER_INSTALL_DEV=0 ;;
  * ) fail "Property dev must be either true or false"
esac

# Dependency: GIT
if [[ ! -n "$(type -t git)" ]]; then
  debug "GIT is not installed"
  info "Consider using a box with GIT pre-installed"

  apt-get update
  apt-get install -y git
fi

# Dependency: ZIP
if [[ ! -n "$(type -t zip)" ]]; then
  debug "ZIP is not installed"
  info "Consider using a box with ZIP pre-installed"

  apt-get update
  apt-get install -y zip
fi

main() {
  if [ "$WERCKER_COMPOSER_INSTALL_USE_CACHE" == "1" ]; then
    info "Using wercker cache"
    setup_cache
  fi

  if [ "$WERCKER_COMPOSER_INSTALL_DEV" == "1" ]; then
    info "Including require-dev"
  else
    info "Skipping require-dev"
  fi

  composer_install

  success "Finished composer install"
}

setup_cache() {
  debug 'Creating $WERCKER_CACHE_DIR/$WERCKER_STEP_OWNER/$WERCKER_STEP_NAME'
  mkdir -p "$WERCKER_CACHE_DIR/$WERCKER_STEP_OWNER/$WERCKER_STEP_NAME"

  debug 'Configuring composer to use wercker cache'
  export COMPOSER_HOME="$WERCKER_CACHE_DIR/$WERCKER_STEP_OWNER/$WERCKER_STEP_NAME"
}

clear_cache() {
  warn "Clearing composer cache"
  $WERCKER_STEP_ROOT/composer.phar clear-cache

  # make sure the cache contains something, so it will override cache that get's stored
  debug 'Creating $WERCKER_CACHE_DIR/$WERCKER_STEP_OWNER/$WERCKER_STEP_NAME'
  mkdir -p "$WERCKER_CACHE_DIR/$WERCKER_STEP_OWNER/$WERCKER_STEP_NAME"
  printf keep > "$WERCKER_CACHE_DIR/$WERCKER_STEP_OWNER/$WERCKER_STEP_NAME/.keep"
}

composer_install() {
  local attempts=3;
  for attempt in $(seq "$attempts"); do
    info "Starting composer install, attempt: $attempt"

    $WERCKER_STEP_ROOT/composer.phar install $WERCKER_COMPOSER_INSTALL_OPTS \
      $( [[ "$WERCKER_COMPOSER_INSTALL_DEV" == "0" ]] && echo "--no-dev" ) \
      && return;

    if [ "$WERCKER_COMPOSER_INSTALL_CLEAR_CACHE_ON_FAILED" == "1" ]; then
      clear_cache
    fi
  done

  fail "Failed to successfully execute composer install, attempts: $attempts"
}

main;
