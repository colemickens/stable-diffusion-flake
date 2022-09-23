#!/usr/bin/env bash

git checkout -b ci/advance-wip
./update.sh
git push origin HEAD -f

./build.sh

# if it worked promote it?
