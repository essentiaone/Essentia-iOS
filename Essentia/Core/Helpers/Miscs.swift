//
//  Miscs.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/18/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

func main(_ closure: @escaping () -> Void) {
    DispatchQueue.main.async(execute: closure)
}

func global(_ closure: @escaping () -> Void) {
    DispatchQueue.global(qos: .background).async(execute: closure)
}

func asyncUIUpdate(backgroud: @escaping () -> Void, uiUpdate:  @escaping () -> Void) {
    global {
        backgroud()
        main {
            uiUpdate()
        }
    }
}
