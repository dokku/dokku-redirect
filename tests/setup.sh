#!/usr/bin/env bash
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/test_helper.bash"

BIN_STUBS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/bin"

if [[ ! -d $DOKKU_ROOT ]]; then
  git clone https://github.com/progrium/dokku.git "$DOKKU_ROOT" > /dev/null
fi

cd "$DOKKU_ROOT"
echo "Dokku version $DOKKU_VERSION"
git checkout "$DOKKU_VERSION" > /dev/null
cd -

rm -rf "$DOKKU_ROOT/plugins/redirect"
mkdir -p "$DOKKU_ROOT/plugins/redirect"
find ./ -maxdepth 1 -type f -exec cp '{}' "$DOKKU_ROOT/plugins/redirect" \;
cp ./templates -r "$DOKKU_ROOT/plugins/redirect"

if [[ ! -f $BIN_STUBS/plugn ]]; then
  wget -O- "$PLUGN_URL" | tar xzf - -C "$BIN_STUBS"
  plugn init
  ln -s "$DOKKU_ROOT"/plugins/* "$DOKKU_ROOT"/plugins/available
  ln -s "$DOKKU_ROOT"/plugins/* "$DOKKU_ROOT"/plugins/enabled
fi

if [[ ! -f $BIN_STUBS/sigil ]]; then
  wget -O- "$SIGIL_URL" | tar xzf - -C "$BIN_STUBS"
fi
