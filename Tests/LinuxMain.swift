import XCTest

import kbc_importTests

var tests = [XCTestCaseEntry]()
tests += kbc_importTests.allTests()
XCTMain(tests)