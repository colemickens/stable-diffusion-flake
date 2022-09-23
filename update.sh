#!/usr/bin/env bash

set -x
set -euo pipefail

nix flake lock --recreate-lock-file --commit-lock-file
