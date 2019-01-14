//
//  LoaderInterface.swift
//  EssCore
//
//  Created by Pavlo Boiko on 12/28/18.
//  Copyright © 2018 Pavlo Boiko. All rights reserved.
//

import Foundation

public protocol LoaderInterface {
    func loaderScope(_ scope: () -> Void)
    func show()
    func hide()
    func showError(_ message: String)
    func showError(_ error: Error)
}
