//
//  Created by Roland Gropmair on 23/10/2018.
//

import Foundation

func printOut(_ string: String) {
    FileHandle.standardOutput.write(string.data(using: .utf8)!)
}

func printlnOut(_ string: String) {
    FileHandle.standardOutput.write("\(string)\n".data(using: .utf8)!)
}
