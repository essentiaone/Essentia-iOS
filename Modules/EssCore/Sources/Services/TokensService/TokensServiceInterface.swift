//
//  TokensServiceInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 16.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssModel

public protocol TokensServiceInterface {
    func updateTokensIfNeeded(_ updated: @escaping () -> Void)
}
