#!/bin/bash

set -eu

function task_build {
  make site
}

function task_watch {
  make watch
}

function task_serve {
  make serve
}

function task_usage {
  echo "usage: $0 build | watch | serve"
  exit 1
}

arg="${1:-}"
shift || true
case "$arg" in
  build) task_build ;;
  watch) task_watch ;;
  serve) task_serve ;;
  *) task_usage ;;
esac
