#!/usr/bin/env bash
export DOKKU_QUIET_OUTPUT=1
export DOKKU_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/dokku"
export DOKKU_VERSION=${DOKKU_VERSION:-"master"}
export PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/bin:$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/dokku:$PATH"
export PLUGIN_PATH="$DOKKU_ROOT/plugins"
export PLUGIN_ENABLED_PATH="$PLUGIN_PATH"
export PLUGIN_AVAILABLE_PATH="$PLUGIN_PATH"
export PLUGIN_CORE_AVAILABLE_PATH="$PLUGIN_PATH"
export PLUGIN_DATA_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/fixtures"
export PLUGN_URL="https://github.com/dokku/plugn/releases/download/v0.2.1/plugn_0.2.1_linux_x86_64.tgz"
export SIGIL_URL="https://github.com/gliderlabs/sigil/releases/download/v0.4.0/sigil_0.4.0_Linux_x86_64.tgz"

mkdir -p "$PLUGIN_DATA_ROOT"
rm -rf "${PLUGIN_DATA_ROOT:?}"/*

flunk() {
  { if [ "$#" -eq 0 ]; then cat -
    else echo "$*"
    fi
  }
  return 1
}

assert_equal() {
  if [ "$1" != "$2" ]; then
    { echo "expected: $1"
      echo "actual:   $2"
    } | flunk
  fi
}

assert_exit_status() {
  assert_equal "$status" "$1"
}

assert_success() {
  if [ "$status" -ne 0 ]; then
    flunk "command failed with exit status $status"
  elif [ "$#" -gt 0 ]; then
    assert_output "$1"
  fi
}

assert_exists() {
  if [ ! -f "$1" ]; then
    flunk "expected file to exist: $1"
  fi
}

assert_contains() {
  if [[ "$1" != *"$2"* ]]; then
    flunk "expected $2 to be in: $1"
  fi
}

assert_output() {
  local expected
  if [ $# -eq 0 ]; then expected="$(cat -)"
  else expected="$1"
  fi
  assert_equal "$expected" "$output"
}
