//
//  Loader.swift
//  Essentia
//
//  Created by Pavlo Boiko on 27.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import SVProgressHUD

class Loader: LoaderInterface {
    init() {
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setDefaultMaskType(.black)
    }
    
    func show() {
        SVProgressHUD.show()
    }
    
    func hide() {
        SVProgressHUD.dismiss()
    }
    
    func showError(message: String) {
        SVProgressHUD.showError(withStatus: message)
    }
    
    func loaderScope(_ scope: () -> Void) {
        show()
        scope()
        hide()
    }
}
