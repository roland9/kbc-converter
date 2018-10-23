import XCTest
import class Foundation.Bundle

final class kbc_importTests: XCTestCase {

    func testReturnsErrorWhenRanWithoutArguments() throws {

        XCTAssertTrue(runScript(filename: nil)?
            .contains("Fatal error: Error raised at top level: expected arguments: input_filename: file") ?? false)
    }

    func testReturnsErrorWhenRanWithFileButDoesNotExist() throws {

        XCTAssertTrue(runScript(filename: "non-existent-filename")?
            .contains("unable to open file") ?? false)
    }

    func testReturnsErrorWhenWrongHeaderLineInFile() throws {

        XCTAssertTrue(runScript(filename: "testinput_1.txt")?
            .contains("wrong header line - expected specific format") ?? false)
    }

    func testReadsLinesCorrectly() throws {

        XCTAssertTrue(runScript(filename: "testinput_2.txt")?
            .contains(
                """
Date\tVendor\tAmount
18 July 2018\tVendor1\t-€4.00
19 July 2018\tVendor with spaces\t€6.00
22 August 2019\tSeller LTD\t-€59.56
"""
            ) ?? false)
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    private func runScript(filename: String?) -> String? {

        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return nil
        }

        let fooBinary = productsDirectory.appendingPathComponent("kbc_import")

        // kbc_importTests.xctest/Contents/Resources/
        let process = Process()
        process.executableURL = fooBinary

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        if let filename = filename {
            process.arguments = ["kbc_importTests.xctest/Contents/Resources/\(filename)"]
        }

        try! process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)
    }
}
