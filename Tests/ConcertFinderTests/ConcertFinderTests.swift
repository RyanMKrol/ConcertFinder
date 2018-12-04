import XCTest
@testable import ConcertFinder

final class ConcertFinderTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ConcertFinder().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
