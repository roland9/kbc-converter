//
//  Created by Roland Gropmair on 23/10/2018.
//

import Foundation

struct Reader {

    var file: String

    init(from file: String) {
        self.file = file
    }

    func parsedLines() throws -> [String] {
        var filename: String

        if NSString(string: file).isAbsolutePath {
            filename = NSString(string: file).standardizingPath as String

        } else {
            let current = FileManager.default.currentDirectoryPath
            filename = current + "/" + NSString(string: file).standardizingPath as String
        }

        guard let file = FileHandle(forReadingAtPath: filename) else {
            throw ParseError.couldNotOpenFile
        }

        let content = try file.readFileContents() as NSString
        file.closeFile()

        let lines = content.components(separatedBy: "\n")

        //    print(lines)

        guard let firstLine = lines.first,
            firstLine == Const.expectedHeaderLine else {
                throw ParseError.wrongHeaderLine
        }

        return lines
    }
}

extension Collection where Iterator.Element == String {

    func formattedOutput() {

        printlnOut(Const.headerlineOutput)

        for line in self {
            let parser = LineParser(line)

            if let date = parser.date() {
                printOut("\(date.formattedMedium())\t")

            } else if let vendor = parser.vendor() {
                printOut("\(vendor)\t")

            } else if let amount = parser.amount(),
                let currency = amount.currency() {
                printOut("\(currency)\n")
            }
        }
    }

}
