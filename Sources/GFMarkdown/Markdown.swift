/// Property wrapper to turn any Markdown variable into HTML.
///
/// Basic usage.
///
/// ```swift
/// struct Content {
///     @Markdown var body: String
/// }
///
/// let content = Content(body: "# Hello")
///
/// // Automatic HTML conversion.
/// print(content.body) // "<h1>Hello</h1>"
/// ```
///
/// Advanced usage.
///
/// ```swift
/// struct Content {
///     @Markdown(
///         options: [.validateUTF8, .unsafe],
///         extensions: [.strikethrough, .tasklist]
///     ) var body: String
/// }
///
/// let content = Content(body: "# Hello")
///
/// // Automatic HTML conversion.
/// print(content.body) // "<h1>Hello</h1>"
///
/// // Retrieve the original Markdown.
/// print(content.$body) // "# Hello"
/// ```
///
@propertyWrapper public struct Markdown {

    /// Converts to HTML using the correct parameters to leverage the defaults from ``MarkdownString``.
    private static func toHTML(_ value: String, options: [CMarkOption]? = .none, extensions: [GFMExtension]? = .none) -> String {

        let mdString = MarkdownString(value)

        if let options = options, let extensions = extensions {
            return mdString.toHTML(options: options, extensions: extensions)
        } else if let options = options {
            return mdString.toHTML(options: options)
        } else if let extensions = extensions {
            return mdString.toHTML(extensions: extensions)
        } else {
            return mdString.toHTML()
        }
    }

    /// The converted HTML value accessible through the wrappedValue property.
    private var html: String

    /// Access the original value before conversion by prefixing the property name with `$`.
    ///
    /// Example.
    ///
    /// ```swift
    /// struct Page {
    ///     @Markdown var content: String
    /// }
    ///
    /// var page = Page(content: "# Hello")
    /// page.content // "<h1>Hello</h1>"
    /// page.$content // "# Hello"
    /// ```
    ///
    public private(set) var projectedValue: String

    /// Custom CommonMark (CMark) options.
    ///
    /// See ``MarkdownString/toHTML(options:extensions:)``and ``CMarkOption``  for more.
    ///
    public private(set) var options: [CMarkOption]?

    /// Custom GitHub Flavored Markdown (GFM) extensions.
    ///
    /// See ``MarkdownString/toHTML(options:extensions:)`` and ``GFMExtension`` for more.
    ///
    public private(set) var extensions: [GFMExtension]?

    /// The HTML translation of the original Markdown value.
    public var wrappedValue: String {

        /// HTML value.
        get {
            html
        }

        /// Applies the Markdown conversion and saves the original value.
        set {
            projectedValue = newValue
            html = Self.toHTML(newValue, options: options, extensions: extensions)
        }
    }

    /// Applies the Markdown conversion and saves the original value.
    public init(wrappedValue: String, options: [CMarkOption]? = .none, extensions: [GFMExtension]? = .none) {
        projectedValue = wrappedValue
        self.options = options
        self.extensions = extensions
        html = Self.toHTML(wrappedValue, options: options, extensions: extensions)
    }
}
