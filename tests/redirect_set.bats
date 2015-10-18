#!/usr/bin/env bats
load test_helper

setup() {
  dokku apps:create my_app >&2
}

teardown() {
  rm "$DOKKU_ROOT/my_app" -rf
}

@test "(redirect:set) error when there are no arguments" {
  run dokku redirect:set
  assert_contains "${lines[*]}" "Please specify an app to run the command on"
}

@test "(redirect:set) error when app does not exist" {
  run dokku redirect:set non_existing_app
  assert_contains "${lines[*]}" "App non_existing_app does not exist"
}

@test "(redirect:set) error when source not provided" {
  run dokku redirect:set my_app
  assert_contains "${lines[*]}" "Please provide a source domain and a destination"
}

@test "(redirect:set) error when destination not provided" {
  run dokku redirect:set my_app ma.dokku.me
  assert_contains "${lines[*]}" "Please provide a source domain and a destination"
}

@test "(redirect:set) success" {
  run dokku redirect:set my_app ma.dokku.me my-app.dokku.me
  redirect=$(< "$DOKKU_ROOT/my_app/REDIRECTS")
  assert_contains "${lines[*]}" "Setting redirect for my_app..."
  assert_equal "$redirect" "ma.dokku.me:my-app.dokku.me"
}

