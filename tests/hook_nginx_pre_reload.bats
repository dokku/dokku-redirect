#!/usr/bin/env bats
load test_helper

setup() {
  dokku apps:create my_app >&2
  dokku redirect:set my_app ma.dokku.me my-app.dokku.me
  touch "$DOKKU_ROOT/my_app/CONTAINER"
}

teardown() {
  rm "$DOKKU_ROOT/my_app" -rf
}

@test "($PLUGIN_COMMAND_PREFIX:hook:nginx-pre-reload) generates nginx config for redirects" {
  dokku nginx:build-config my_app
  grep -q ma.dokku.me "$DOKKU_ROOT/my_app/nginx.conf"
}
