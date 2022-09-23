#!/usr/bin/env bash

set -x
set -euo pipefail

nix flake lock --accept-flake-config

# target=".#devShells.x86_64-linux.webui.inputDerivation"
target=".#devShells.x86_64-linux.webui-pip.inputDerivation"
nix build "${target}" --out-link /tmp/result-devshell

if [[ "${CACHIX_SIGNING_KEY:-""}" != "" ]]; then
  readlink -f ./result-devshell | cachix push stable-diff
fi
