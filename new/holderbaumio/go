#!/bin/bash

set -eu

function ensure_bundler {
  if [[ ! -d vendor ]];
  then
    bundle install --path vendor/bundle
    touch vendor
  fi

  if [[ Gemfile -nt vendor ]] || [[ Gemfile.lock -nt vendor ]];
  then
    bundle update
    touch vendor
  fi
}

function task_watch {
  ensure_bundler
  bundle exec foreman start
}

function task_build {
  ensure_bundler
  bundle exec sass --scss --style compressed sass/main.scss:static/css/main.css
  hugo
}


function task_deploy {
  rsync -ruv --delete public/* deploy-holderbaum-io@turing.holderbaum.me:www/
}

function task_usage {
  echo "usage: $0 watch | build | deploy"
  exit 1
}

arg="${1:-}"
shift || true
case "$arg" in
  watch) task_watch ;;
  build) task_build ;;
  deploy) task_deploy ;;
  *) task_usage ;;
esac
