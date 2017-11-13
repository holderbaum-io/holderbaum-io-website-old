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

function task_prepare_ci {
  go get -u -v github.com/spf13/hugo
  if [[ $TRAVIS_PULL_REQUEST == "false" && $TRAVIS_BRANCH == "master" ]] ;
  then
    openssl aes-256-cbc -K $encrypted_29bdd84813a9_key -iv $encrypted_29bdd84813a9_iv -in id_rsa.enc -out id_rsa -d
    chmod 600 id_rsa
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
  if [[ -f id_rsa ]];
  then
    eval "$(ssh-agent -s)"
    ssh-add id_rsa
  fi
  rsync -ruv --delete public/* deploy-holderbaum-io@turing.holderbaum.me:www/
}

function task_usage {
  echo "usage: $0 watch | build | deploy"
  exit 1
}

arg="${1:-}"
shift || true
case "$arg" in
  prepare-ci) task_prepare_ci ;;
  watch) task_watch ;;
  build) task_build ;;
  deploy) task_deploy ;;
  *) task_usage ;;
esac
