#!/usr/bin/env bash

set -x
set -euo pipefail

nix build ".#devShells.x86_64-linux.working.inputDerivation" --out-link ./result-devshell-working
readlink -f ./result-devshell-working | cachix push stable-diff

nix build ".#devShells.x86_64-linux.default.inputDerivation" --out-link /tmp/result-devshell
readlink -f ./result-devshell | cachix push stable-diff
