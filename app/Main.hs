module Main (main) where

import System.Environment
import System.IO
import Control.Monad
import Data.List
import MdToHtml
import Server


main :: IO ()
main = do
    args <- getArgs
    progName <- getProgName
    putStrLn progName

    _ <- if null args then
        error "Missing a markdown filepath as an argument!"
    else putStrLn ""

    handle <- openFile (head args) ReadMode
    contents <- hGetContents handle

    let lineList = lines contents

    let parsedLines = parseContents lineList

    let parsedContent = intercalate "\n" parsedLines
    serve parsedContent

    hClose handle
