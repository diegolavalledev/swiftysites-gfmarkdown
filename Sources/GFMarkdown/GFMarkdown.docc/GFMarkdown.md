# ``GFMarkdown``

Convert GitHub Flavored Markdown to HTML easily with the `@Markdown` property wrapper. Optionally customize every CMark option and GFM extension available.

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

Just tag your properties with the ``Markdown`` wrapper.

```swift
struct Content {
    @Markdown var body: String
}

let content = Content(body: "# Hello")

// Automatic HTML conversion.
print(content.body) // "<h1>Hello</h1>"

// Retrieve the original Markdown.
print(content.$body) // "# Hello"
```

Alternativelly wrap your Markdown string with ``MarkdownString`` and call ``MarkdownString/toHTML(options:extensions:)`` with no parameters.

```swift
let html = GFMarkdown("# Hello").toHTML()
print(html) // "<h1>Hello</h1>"
```

## Topics

### Converting Markdown to HTML

- ``Markdown``
- ``MarkdownString/toHTML(options:extensions:)``

### Specifying options and extensions

- ``CMarkOption``
- ``GFMExtension``
