module MdToHtml (parseLine, parseContents) where

import Data.List (isPrefixOf)
import Text.Regex.Posix ((=~))


getPrefix :: String -> String -> String
getPrefix mdLine prev
    | "* " `isPrefixOf` mdLine && not ("* " `isPrefixOf` prev) = "<ul>\n"
    | mdLine =~ "^[0-9]+\\." && not (prev =~ "^[0-9]+\\.") = "<ol>\n"
    | otherwise = ""

getPostfix :: String -> String -> String
getPostfix mdLine next
    | "* " `isPrefixOf` mdLine && not ("* " `isPrefixOf` next) = "\n</ul>"
    | mdLine =~ "^[0-9]+\\." && not (next =~ "^[0-9]+\\.") = "\n</ol>"
    | otherwise = ""

parseLine :: String -> String -> String -> String
parseLine mdLine prev next = do
    let prefix = getPrefix mdLine prev
    let postfix = getPostfix mdLine next
    let result | "# " `isPrefixOf` mdLine = "<h1>" ++ drop 2 mdLine ++ "</h1>"
               | "## " `isPrefixOf` mdLine = "<h2>" ++ drop 3 mdLine ++ "</h2>"
               | "### " `isPrefixOf` mdLine = "<h3>" ++ drop 4 mdLine ++ "</h3>"
               | "#### " `isPrefixOf` mdLine = "<h4>" ++ drop 5 mdLine ++ "</h4>"
               | "> " `isPrefixOf` mdLine = "<blockquote style=\"background-color: lightgrey; border-left: solid grey; padding: 10px\">" ++ drop 2 mdLine ++ "</blockquote>"
               | mdLine =~ "^[0-9]+\\." = prefix ++ "<li>" ++ drop 2 mdLine ++ "</li>" ++ postfix
               | mdLine =~ "^(-{3,}|_{3,})" = "<hr>"
               | "* " `isPrefixOf` mdLine = prefix ++ "<li>" ++ drop 2 mdLine ++ "</li>" ++ postfix
               | "```" == mdLine = "</blockquote>"
               | "```" `isPrefixOf` mdLine = "<blockquote style=\"background-color: lightgrey; padding: 10px; font-family: monospace;\">"
               | "" == mdLine = "<br>"
               | otherwise = mdLine
    result


lineMap :: (String -> String -> String -> String) -> [String] -> String -> [String]
lineMap f (x:xs) prev
    | null (x:xs) = []
    | null xs = [f x prev ""]
    | otherwise = f x prev (head xs) : lineMap f xs x

parseContents :: [String] -> [String]
parseContents mdLines = lineMap parseLine (mdLines++[""]) ""
