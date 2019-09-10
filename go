#!/bin/bash

set -eu

function ensure_bundler {
  if [[ ! -d vendor/bundle ]];
  then
    bundle install --path vendor/bundle
    touch vendor/bundle
  fi

  if [[ Gemfile -nt vendor/bundle ]] || [[ Gemfile.lock -nt vendor/bundle ]];
  then
    bundle update
    touch vendor/bundle
  fi
}

function ensure_hugo {
  if [[ -f vendor/hugo ]];
  then
    return
  fi

  mkdir -p vendor
  (
    cd vendor
    wget https://github.com/gohugoio/hugo/releases/download/v0.30.2/hugo_0.30.2_Linux-64bit.tar.gz
    echo 'a192577471f2c5b7a6f26ce8ec6effd9e274ffb8672c1a810af0a6384b4de8cd  hugo_0.30.2_Linux-64bit.tar.gz' | sha256sum -c -
    tar xf hugo_0.30.2_Linux-64bit.tar.gz hugo
    rm -f hugo_0.30.2_Linux-64bit.tar.gz
  )
}

function ensure_wt {
  if [[ -f vendor/wt ]];
  then
    return
  fi

  mkdir -p vendor
  (
    cd vendor
    wget https://github.com/wellington/wellington/releases/download/v1.0.4/wt_v1.0.4_linux_amd64.tar.gz
    echo 'f0f8ad2461b16e6277b863b092826a9d0c066877c3ea13bd79694d327e800d3d  wt_v1.0.4_linux_amd64.tar.gz' | sha256sum -c -
    tar xf wt_v1.0.4_linux_amd64.tar.gz wt
    rm -f wt_v1.0.4_linux_amd64.tar.gz
  )
}

function prepare_ci {
  if [[ -z "${CI:=}" ]]; then return 0; fi

  apt-get update
  apt-get \
    install \
    -y \
    lftp

}

function task_watch {
  ensure_hugo
  ensure_wt
  ensure_bundler

  bundle exec foreman start
}

function task_build {
  ensure_hugo
  ensure_wt

  vendor/wt compile sass/main.scss --build=static/css/ --style="compressed"
  vendor/hugo
}

function task_deploy {
  prepare_ci

  lftp \
    -c " \
      open $DEPLOY_USER:$DEPLOY_PASS@www151.your-server.de; \
      mirror --reverse --verbose --delete public/ .; \
      "
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
