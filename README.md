# MdToWeb

A simple markdown to HTML converter and server program.  Written in Haskell, this program reads in markdown from a file, parses it into valid HTML and serves it to localhost.

## Usage

The `mdToWeb-exe` executable takes in the name of a markdown file as its first argument and launches an HTTP server that serves the converted HTML string.

## Quick Start

1. Build the executable

    ```bash
    stack build
    ```

2. Run the executable

    ```bash
    stack run path/to/markdown.md
    ```
