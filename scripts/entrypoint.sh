#!/bin/sh

INITALIZED="/.initialized"

# First time initialisation
if [ ! -f "$INITALIZED" ]; then
  echo ">> CONTAINER: starting initialisation"

  # Set as initialized
  touch "$INITALIZED"
else
  echo ">> CONTAINER: already initialized"
  echo ">> STARTING SERVICES"
fi

exec "$@"
