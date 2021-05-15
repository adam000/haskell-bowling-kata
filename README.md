## About

This is a Kata I completed to learn some basics of Haskell. I ended up learning about Cabal and HUnit / Tasty in the process, too.

If I were to spend more time on this, I would add a lot more test cases. I only wanted to test a couple cases of `validate`, and I'm sure there's a lot more I could test for `score` as well.

I completed this in about 2.5 hours, but I had already completed the F# version as a [Kata at work](https://github.com/adam-hintz-olo/scratch/blob/main/bowling-kata-fsharp/bowl.fsx) for learning F#. My goals were slightly different here -- I focused on learning a testing framework's basics and also developing a validation function for this case.

### Cabal

Cabal is apparently a main way people build things in Haskell, so this is how I got Haskell set up on my Mac:

```
brew install ghc
brew install cabal-install
```

After that, I used `cabal` to install the testing framework as a library so I could access it:

```
cabal install --lib HUnit
cabal install --lib tasty-hunit
```

And to run my example program or the unit tests:

```
cabal run Bowling
cabal run unit-tests
```

### Other notes

I left a couple bash scripts from before I was learning `cabal` -- in general these should not be used, but `compile.bash` includes `-Wall` to get warnings about incomplete pattern matches and hides a silly warning I was getting because of Homebrew / Mac OS 11 having some link issues. `test.bash` probably doesn't work because I only focused on getting tests working in `cabal`.
