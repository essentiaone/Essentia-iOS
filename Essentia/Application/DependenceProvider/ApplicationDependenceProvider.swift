//
//  ApplicationDependenceProvider.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class ApplicationDependenceProvider {
    func loadDependences() {
        loadCoreDependences()
        loadLoginDependences()
    }
    
    private func loadCoreDependences() {
        loadColorSheme()
    }
    
    private func loadColorSheme() {
        let injection: AppColorInterface = DefaultColorSheme()
        prepareInjection(injection, memoryPolicy: .viewController)
    }
    
    private func loadLoginDependences() {
        loadLoginDesign()
    }
    
    private func loadLoginDesign() {
        let injection: LoginDesignInterface = LoginDesign()
        prepareInjection(injection, memoryPolicy: .viewController)
    }
}
