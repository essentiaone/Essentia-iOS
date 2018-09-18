//
//  TokensServiceInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 16.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

protocol TokensServiceInterface {
    func getTokensList(_ callBack: @escaping ([Token]) -> Void)
}
