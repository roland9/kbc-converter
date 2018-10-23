//
//  Created by Roland Gropmair on 23/10/2018.
//

import Foundation

enum ArgumentError: Error {
    case argumentNotFound
}

enum ParseError: Error {
    case wrongHeaderLine
    case couldNotOpenFile
}

protocol CustomErrorMessage {
    var customErrorMessage: String { get }
}

extension ParseError: CustomErrorMessage {

    var customErrorMessage: String {
        switch self {
        case .wrongHeaderLine:
            return "\(Const.Colors.red)wrong header line - expected specific format: \(Const.Colors.blueUnderlined)'\(Const.expectedHeaderLine)'\n"
        case .couldNotOpenFile:
            return "\(Const.Colors.red)unable to open file - are you sure you have the correct file name?\n"
        }
    }
}
