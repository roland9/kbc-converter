//
//  Created by Roland Gropmair on 23/10/2018.
//

import Foundation
import Utility

extension Collection where Iterator.Element == String {

    func findFilename() throws -> String {

        // The first argument is always the executable, drop it
        let arguments = Array(self.dropFirst())

        let parser = ArgumentParser(usage: "<input_filename>", overview: "Converts an export of KBC Ireland transations")

        let filenameArgument = parser.add(positional: "input_filename", kind: String.self,
                                          optional: false, usage: "a filename to read from", completion: .filename)

        let parsedArguments = try parser.parse(arguments)

        // will not throw our exception here - because it catches that error condition before?
        guard let input = parsedArguments.get(filenameArgument) else { throw ArgumentError.argumentNotFound }

        return input
    }
}
