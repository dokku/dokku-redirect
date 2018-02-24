#!/usr/bin/env bats
load test_helper

setup() {
  dokku apps:create my_app >&2
}

teardown() {
  rm -rf "$DOKKU_ROOT/my_app"
}

@test "(redirect) error when there are no arguments" {
  run dokku redirect
  assert_contains "${lines[*]}" "Please specify an app to run the command on"
}

@test "(redirect) error when app does not exist" {
  run dokku redirect non_existing_app
  assert_contains "${lines[*]}" "App non_existing_app does not exist"
}

@test "(redirect) message when there are no redirects" {
  run dokku redirect my_app
  assert_contains "${lines[*]}" "There are no redirects for my_app"
}

@test "(redirect) list redirects when present" {
  dokku redirect:set my_app ma.dokku.me my-app.dokku.me
  run dokku redirect my_app
  assert_contains "${lines[*]}" "ma.dokku.me  my-app.dokku.me  301"
}
