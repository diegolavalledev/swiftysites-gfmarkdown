/// GFM extensions.
public enum GFMExtension: String {

    /// Spec [here](https://github.github.com/gfm/#tables-extension-)
    case table

    /// Spec [here](https://github.github.com/gfm/#tables-extension-)
    case tasklist

    /// Spec [here](https://github.github.com/gfm/#strikethrough-extension-)
    case strikethrough

    /// Spec [here](https://github.github.com/gfm/#autolinks-extension-)
    case autolink

    /// Spec [here](https://github.github.com/gfm/#disallowed-raw-html-extension-)
    case tagfilter
}
