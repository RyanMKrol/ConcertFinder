import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ConcertFinderTests.allTests),
    ]
}
#endif