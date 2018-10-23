import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(kbc_importTests.allTests),
    ]
}
#endif