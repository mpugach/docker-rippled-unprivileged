#!/bin/bash
set -e

if [[ $(echo "$1" | cut -c1) = "-" ]]; then
  echo "$0: assuming arguments for rippled"

  set -- vertcoind "$@"
fi

if [[ $(echo "$1" | cut -c1) = "-" ]] || [[ "$1" = "rippled" ]]; then
  mkdir -p "$RIPPLE_DATA"
  chmod 700 "$RIPPLE_DATA"
  chown -R ripple "$RIPPLE_DATA"

  echo "$0: setting data directory to $RIPPLE_DATA"

  set -- "$@"
fi

if [[ "$1" = "rippled" ]]; then
  echo
  exec gosu ripple "$@"
fi

echo
exec "$@"
