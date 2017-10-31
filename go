#!/bin/bash

set -eu

function task_build {
  rsync -ru static/* out/assets/
  mkdir -p out/articles
  cp content/articles.html out/articles/index.html || true
  cp content/articles/SharedSecrets.html out/articles/SharedSecrets.html || true
  bundle exec sass --scss style/main.scss out/main.css || true
  ./script/compile_page.sh content/index.markdown out
}

function task_watch {
  while true;
  do
    task_build
    inotifywait -r -e modify,close_write,moved_to,moved_from,move,move_self,create,delete,delete_self content style static && task_build
  done
}

function task_serve {
  (
    cd out
    python -m http.server 9090
  )
}

function task_deploy {
  rsync -ruv --delete out/* deploy-holderbaum-io@turing.holderbaum.me:www/
}

function task_usage {
  echo "usage: $0 build | watch | serve | deploy"
  exit 1
}

arg="${1:-}"
shift || true
case "$arg" in
  build) task_build ;;
  watch) task_watch ;;
  serve) task_serve ;;
  deploy) task_deploy ;;
  *) task_usage ;;
esac
