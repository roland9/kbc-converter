//
//  Created by Roland Gropmair on 21/10/2018.
//

import Foundation

struct LineParser {

    let line: String

    init(_ line: String) {
        self.line = line
    }

    func date() -> Date? {
        return line.dateFromMedium()
    }

    func vendor() -> String? {

        if line.hasPrefix("POS ") ||
            line.hasPrefix("C-POS ") {

            let new = line
                .replacingOccurrences(of: "C-POS ", with: "")
                .replacingOccurrences(of: "POS ", with: "")
            let length = new.lengthOfBytes(using: .utf8)
            guard length > 8 else { return nil }

            let regex = try! NSRegularExpression(pattern: "[0-9]+", options: .caseInsensitive)
            let result = regex.matches(in: new, options: [], range: NSRange(location: length - 8, length: 8))

            if result.first?.numberOfRanges == 1 {
                return String(new.dropLast(9))
            } else {
                return nil
            }

        } else {
            return nil
        }
    }

    func amount() -> NSNumber? {

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_IE")

        let regex = try! NSRegularExpression(pattern: "[-€£$0-9,.]+", options: [])
        let result = regex.firstMatch(in: line, options: .anchored, range: NSRange(location: 0, length: line.count))

        // TODO handle other currencies
        if let range = result?.range,
            let swiftRange = Range(range) {
            let new = line[swiftRange]
            return formatter.number(from: new)
        } else {
            return nil
        }
    }
}
