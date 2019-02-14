//
//  Error+Description.swift
//  EssCore
//
//  Created by Pavlo Boiko on 2/14/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation
import EssentiaNetworkCore
import EssModel

public extension Error {
    public var description: String {
        switch self {
        case let error as EssentiaNetworkError:
            return error.localizedDescription
        case let error as EssentiaError:
            return error.localizedDescription
        default:
            return localizedDescription
        }
    }
}
