#/usr/bin/env bash

rm bowling-test
# This warning is something silly going on with my current version of ghc -- homebrew / Mac OS 11 issue
ghc bowling-test.hs bowling.hs -Wall 2>&1 | grep -v "was built for newer"
