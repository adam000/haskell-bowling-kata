#/usr/bin/env bash

rm bowling-interface
# This warning is something silly going on with my current version of ghc -- homebrew / Mac OS 11 issue
ghc bowling-interface.hs bowling.hs -Wall 2>&1 | grep -v "was built for newer"
