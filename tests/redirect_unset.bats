#!/usr/bin/env bats
load test_helper

setup() {
  dokku apps:create my_app >&2
  dokku redirect:set my_app ma.dokku.me my-app.dokku.me >&2
}

teardown() {
  rm "$DOKKU_ROOT/my_app" -rf
}

@test "(redirect:unset) error when there are no arguments" {
  run dokku redirect:unset
  assert_contains "${lines[*]}" "Please specify an app to run the command on"
}

@test "(redirect:unset) error when app does not exist" {
  run dokku redirect:unset non_existing_app
  assert_contains "${lines[*]}" "App non_existing_app does not exist"
}

@test "(redirect:unset) error when source not provided" {
  run dokku redirect:unset my_app
  assert_contains "${lines[*]}" "Please provide a source domain"
}

@test "(redirect:unset) success" {
  run dokku redirect:unset my_app ma.dokku.me
  [[ ! -s $DOKKU_ROOT/my_app/REDIRECTS ]]
  assert_contains "${lines[*]}" "Unsetting redirect for my_app..."
}

