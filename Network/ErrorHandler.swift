//
//  ErrorHandler.swift
//
//  Created by Mohammed Sami on 14/3/18.
//  Copyright © 2018 Mohammed Sami. All rights reserved.
//

import UIKit

enum NError: Error {
    case ConnectionError
    case ServerError(code: Int,reason: String)
    case ParseError
}
