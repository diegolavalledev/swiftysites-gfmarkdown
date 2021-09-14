import XCTest
import GFMarkdown

final class MarkdownStringTests: XCTestCase {

    func testBasicConversion() throws {
        let markdown = MarkdownString("# Hello")
        let html = markdown.toHTML()
        XCTAssertEqual(html, "<h1>Hello</h1>\n")
        XCTAssertEqual(markdown.description, "# Hello")
    }
}
