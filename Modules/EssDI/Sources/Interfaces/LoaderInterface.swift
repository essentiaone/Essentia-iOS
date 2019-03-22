//
//  LoaderInterface.swift
//  EssDI
//
//  Created by Pavlo Boiko on 2/1/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation

public protocol LoaderInterface {
    func loaderScope(_ scope: () -> Void)
    func show()
    func hide()
    func showError(_ message: String)
    func showInfo(_ message: String)
}
