#if canImport(Glibc)
    import Glibc
#endif

import CMarkGFMPlus

/// Wrapper for strings containing Markdown code.
///
/// ## Basic usage
///
/// ```swift
/// let markdown = MarkdownString("# Hello")
/// let html = markdown.toHTML()
/// print(html) // "<h1>Hello</h1>"
/// print(markdown.description) // "# Hello"
/// ```
///
public struct MarkdownString {

    /// Default CMark options: ``CMarkOption/githubPreLang``, ``CMarkOption/tablePreferStyleAttributes``.
    public static let defaultOptions: [CMarkOption] = [
        .githubPreLang, .tablePreferStyleAttributes
    ]

    /// Default GFM extensions: ``GFMExtension/strikethrough``, ``GFMExtension/autolink``, ``GFMExtension/tagfilter``.
    public static let defaultExtensions: [GFMExtension] = [
        .strikethrough, .autolink, .tagfilter
    ]

    private let markdown: String

    /// Wraps up a _String_ with Markdown inside.
    ///
    /// - Parameter markdown: The string being wrapped.
    public init(_ markdown: String) {
        self.markdown = markdown
    }

    /// Renders HTML code from the initial Markdown content.
    ///
    /// - Parameters:
    ///   - options: CMark options. Defaults: ``defaultOptions``.
    ///   - extensions: GFM extensions. Defaults: ``defaultExtensions``.
    ///
    public func toHTML(options: [CMarkOption] = Self.defaultOptions, extensions: [GFMExtension] = Self.defaultExtensions) -> String {

        // Create [UnsafeMutablePointer<Int8>]:
        var extensions = extensions.map { strdup($0.rawValue) }

        let outString = cmark_gfm_markdown_to_html(markdown, markdown.utf8.count, options.code, &extensions, Int32(extensions.count))!

        // Free the duplicated strings:
        for ptr in extensions { free(ptr) }

        defer { free(outString) }
        return String(cString: outString)
    }
}

extension MarkdownString: LosslessStringConvertible {

    public var description: String {
        markdown
    }
}
