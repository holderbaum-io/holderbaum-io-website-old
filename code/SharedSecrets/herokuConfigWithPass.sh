$ export PASSWORD_STORE_DIR=~/code/app/secrets
$ export USER=`pass show production/user`
$ export TOKEN=`pass show production/api_token`
$ heroku config:set GITHUB_USER=$USER \
                    GITHUB_API_TOKEN=$TOKEN
