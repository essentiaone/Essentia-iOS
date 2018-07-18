//
//  Application.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class Application: UIApplication {
    private let dependencePrivader: ApplicationDependenceProvider
    
    override init() {
        dependencePrivader = ApplicationDependenceProvider()
        dependencePrivader.loadDependences()
    }
}
