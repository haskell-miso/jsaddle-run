jsaddle-run
===================

An abstraction over jsaddle for various backends (GHCJS, WASM, GHC)

Abstracts over:
  - [jsaddle-wasm](https://github.com/amesgen/jsaddle-wasm)
  - [jsaddle-warp](https://hackage.haskell.org/package/jsaddle-warp)

### Dev

```nix-shell
$ nix-shell
```

### Build

```nix-shell
$ nix-build
```

### Usage

```haskell
module Main where

import Language.Javascript.JSaddle.Run (run)

main :: IO ()
main = run code

code :: JSM ()
code = undefined -- your code goes here
```



