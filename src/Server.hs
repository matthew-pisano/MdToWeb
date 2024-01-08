{-# LANGUAGE OverloadedStrings #-}

module Server (serve) where

import Network.Wai (responseLBS, Application)
import Network.Wai.Handler.Warp (run)
import Network.HTTP.Types (status200)
import Network.HTTP.Types.Header (hContentType)
import Data.ByteString.Lazy.UTF8 as BLU

serve :: String -> IO ()
serve content = do
  let port = 3000
  putStrLn ("Listening on port " <> show port)
  run port (app content)

app :: String -> Application
app content _req f = f (responseLBS status200 [(hContentType, "text/html")] (BLU.fromString content))
