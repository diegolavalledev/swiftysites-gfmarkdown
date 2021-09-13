import XCTest
import GFMarkdown

final class MarkdownStringTests: XCTestCase {

    func testBasicConversion() throws {
        let result = MarkdownString("# Hello").toHTML()
        XCTAssertEqual(result, "<h1>Hello</h1>\n")
    }
}
