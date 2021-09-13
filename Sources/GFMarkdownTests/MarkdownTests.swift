import XCTest
import GFMarkdown

final class MarkdownTests: XCTestCase {

    func testPropertyWrapper() throws {
        @Markdown var content = "# Hello"
        XCTAssertEqual(content, "<h1>Hello</h1>\n")
        XCTAssertEqual($content, "# Hello")
        content = "# Goodbye"
        XCTAssertEqual(content, "<h1>Goodbye</h1>\n")
        XCTAssertEqual($content, "# Goodbye")
    }

    func testDelayedInit() throws {
        @Markdown var content: String
        content = "# Hello"
        XCTAssertEqual($content, "# Hello")
        XCTAssertEqual(content, "<h1>Hello</h1>\n")
        content = "# Goodbye"
        XCTAssertEqual(content, "<h1>Goodbye</h1>\n")
        XCTAssertEqual($content, "# Goodbye")
    }

    func testOptions() throws {
        @Markdown(options: [], extensions: []) var content: String = "~Hello~"
        XCTAssertEqual($content, "~Hello~")
        XCTAssertEqual(content, "<p>~Hello~</p>\n")
        content = "~Goodbye~"
        XCTAssertEqual(content, "<p>~Goodbye~</p>\n")
        XCTAssertEqual($content, "~Goodbye~")
        @Markdown(options: [], extensions: [.strikethrough]) var content2: String = "~Hello~"
        XCTAssertEqual($content2, "~Hello~")
        XCTAssertEqual(content2, "<p><del>Hello</del></p>\n")
        content2 = "~Goodbye~"
        XCTAssertEqual(content2, "<p><del>Goodbye</del></p>\n")
        XCTAssertEqual($content2, "~Goodbye~")
        XCTAssert(_content2.extensions?.contains(.strikethrough) == true)
    }
}
