#!/bin/bash

set -eu

function task_build {
  rsync -ru static/* out/assets/
  bundle exec sass --scss style/main.scss out/main.css
  ./script/compile_page.sh content/index.markdown out
  ./script/compile_page.sh content/about.markdown out
  ./script/compile_page.sh content/mentoring.markdown out
}

function task_watch {
  task_build
  while true;
  do
    inotifywait -e modify,close_write,moved_to,moved_from,move,move_self,create,delete,delete_self content style static && task_build
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
