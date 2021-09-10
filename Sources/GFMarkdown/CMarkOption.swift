import CMarkGFMPlus

/// CommonMark option values.
///
/// ## Options affecting rendering
///
/// ``sourcePos``, ``hardBreaks``, ``safe``, ``unsafe``, ``noBreaks``.
///
/// ## Options affecting parsing
///
/// ``normalize``, ``validateUTF8``, ``smart``, ``githubPreLang``, ``liberalHTMLTag``, ``footnotes``, ``strikethroughDoubleTilde``, ``tablePreferStyleAttributes``, ``fullInfoString``.
///
public enum CMarkOption {

    /// Include a `data-sourcepos` attribute on all block elements.
    case sourcePos

    /// Render `softbreak` elements as hard line breaks.
    case hardBreaks

    /// `CMARK_OPT_SAFE` is defined here for API compatibility, but it no longer has any effect. "Safe" mode is now the default: set `CMARK_OPT_UNSAFE` to disable it.
    case safe

    /// Render raw HTML and unsafe links (`javascript:`, `vbscript:`, `file:`, and `data:`, except for `image/png`, `image/gif`, `image/jpeg`, or `image/webp` mime types).  By default, raw HTML is replaced by a placeholder HTML comment. Unsafe links are replaced by empty strings.
    case unsafe

    /// Render `softbreak` elements as spaces.
    case noBreaks

    /// Legacy option (no effect).
    case normalize

    /// Validate UTF-8 in the input before parsing, replacing illegal sequences with the replacement character U+FFFD.
    case validateUTF8

    /// Convert straight quotes to curly, --- to em dashes, -- to en dashes.
    case smart

    /// Use GitHub-style `<pre lang="x">` tags for code blocks instead of `<pre><code class="language-x">`.
    case githubPreLang

    /// Be liberal in interpreting inline HTML tags.
    case liberalHTMLTag

    /// Parse footnotes.
    case footnotes

    /// Only parse strikethroughs if surrounded by exactly 2 tildes. Gives some compatibility with redcarpet.
    case strikethroughDoubleTilde

    /// Use style attributes to align table cells instead of align attributes.
    case tablePreferStyleAttributes

    /// Include the remainder of the info string in code blocks in a separate attribute.
    case fullInfoString

    internal var code: Int32 {
        switch(self) {
            case .sourcePos:
                return CMARK_OPT_SOURCEPOS
            case .hardBreaks:
                return CMARK_OPT_HARDBREAKS
            case .safe:
                return CMARK_OPT_SAFE
            case .unsafe:
                return CMARK_OPT_UNSAFE
            case .noBreaks:
                return CMARK_OPT_NOBREAKS
            case .normalize:
                return CMARK_OPT_NORMALIZE
            case .validateUTF8:
                return CMARK_OPT_VALIDATE_UTF8
            case .smart:
                return CMARK_OPT_SMART
            case .githubPreLang:
                return CMARK_OPT_GITHUB_PRE_LANG
            case .liberalHTMLTag:
                return CMARK_OPT_LIBERAL_HTML_TAG
            case .footnotes:
                return CMARK_OPT_FOOTNOTES
            case .strikethroughDoubleTilde:
                return CMARK_OPT_STRIKETHROUGH_DOUBLE_TILDE
            case .tablePreferStyleAttributes:
                return CMARK_OPT_TABLE_PREFER_STYLE_ATTRIBUTES
            case .fullInfoString:
                return CMARK_OPT_FULL_INFO_STRING
        }
    }
}

extension Array where Element == CMarkOption {

    var code: Int32 {
        guard count > 0 else {
            return CMARK_OPT_DEFAULT
        }
        return map(\.code).reduce(CMARK_OPT_DEFAULT) {
            $0 | $1
        }
    }
}

