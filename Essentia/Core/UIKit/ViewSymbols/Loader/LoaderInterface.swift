//
//  LoaderInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 27.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

protocol LoaderInterface {
    func loaderScope(_ scope: () -> Void) 
    func show()
    func hide()
    func showError(_ message: String)
    func showError(_ error: Error)
}
