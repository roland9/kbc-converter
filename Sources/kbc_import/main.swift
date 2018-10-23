//
//  Created by Roland Gropmair on 21/10/2018.
//

import Foundation

do {

    let arguments = Array(ProcessInfo.processInfo.arguments)

    let filename = try arguments.findFilename()

    try Reader(from: filename)
        .parsedLines()
        .formattedOutput()

} catch ArgumentError.argumentNotFound {
    printOut("argument not found")

} catch where error is CustomErrorMessage {
    printOut((error as! CustomErrorMessage)
        .customErrorMessage)
}
