//
//  LoginInteractorInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 23.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

protocol LoginInteractorInterface {
    func generateNewUser(callBack:@escaping () -> Void)
    func createNewUser(generateAccount: @escaping () -> Void, openPurchase: @escaping () -> Void)
}
