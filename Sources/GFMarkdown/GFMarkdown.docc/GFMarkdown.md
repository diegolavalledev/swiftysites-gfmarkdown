# ``CMarkGFM``

Easily render HTML from standard Markdown content.

## Overview

Use this library to generate HTML from a string containing [GitHub Flavored Markdown (GFM)](https://github.github.com/gfm/) / [CommonMark](https://commonmark.org) content.

For example this code:

```markdown
# Hello
Hello, _World_!
```

Will be translated into this code:

```html
<h1>Hello</h1>
<p>Hello, <em>World<em>!</p>
```

## Acknowledgements

This implementation is built entirely on top of the amazing [cmark-gfm](https://github.com/github/cmark-gfm) which itself is a fork of the excellent [cmark](https://github.com/commonmark/cmark).

## Basic usage

Simply wrap your Markdown string with ``GFMarkdown`` and call ``GFMarkdown/toHTML(options:extensions:)`` with no parameters.

```swift
let html = GFMarkdown("# Hello").toHTML()
print(html) // "<h1>Hello</h1>"
```

## Topics

### Converting Markdown to HTML

- ``GFMarkdown/toHTML(options:extensions:)``

### Specifying options and extensions

- ``CMarkOption``
- ``GFMExtension``
