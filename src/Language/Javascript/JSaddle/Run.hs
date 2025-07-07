-----------------------------------------------------------------------------
{-# LANGUAGE CPP #-}
{-# LANGUAGE OverloadedStrings #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  Language.Javascript.JSaddle.Run
-- Copyright   :  (C) 2016-2025 David M. Johnson
-- License     :  BSD3-style (see the file LICENSE)
-- Maintainer  :  David M. Johnson <code@dmj.io>
-- Stability   :  experimental
-- Portability :  non-portable
----------------------------------------------------------------------------
module Language.Javascript.JSaddle.Run
  ( -- ** Execution
    run
  ) where
-----------------------------------------------------------------------------
#ifdef WASM
import qualified Language.Javascript.JSaddle.Wasm as J
#elif !GHCJS_BOTH
import           Data.Maybe
import           System.Environment
import           Text.Read
import qualified Language.Javascript.JSaddle.Warp as J
#endif
import           Language.Javascript.JSaddle
-----------------------------------------------------------------------------
-- | When compiling with jsaddle on native platforms
-- 'run' will start a web server for live reload
-- of your application.
--
-- When compiling to WASM this will use 'jsaddle-wasm'.
-- When compiling to JS (via jsaddle-warp) no special package is
-- required (simply the 'id' function). JSM becomes a type synonym for IO.
run :: JSM () -> IO ()
#ifdef WASM
run = J.run
#elif GHCJS_BOTH
run = id
#else
run action = do
    port <- fromMaybe 8008 . (readMaybe =<<) <$> lookupEnv "PORT"
    isGhci <- (== "<interactive>") <$> getProgName
    putStrLn $ "Running on port " <> show port <> "..."
    (if isGhci then J.debug else J.run) port action
#endif
-----------------------------------------------------------------------------
