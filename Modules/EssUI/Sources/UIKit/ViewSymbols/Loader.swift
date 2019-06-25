//
//  Loader.swift
//  EssUI
//
//  Created by Pavlo Boiko on 2/1/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation
import SVProgressHUD
import EssModel
import EssResources
import EssDI

public class Loader: LoaderInterface {
    public init() {
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setDefaultMaskType(.black)
    }
    
    public func show() {
        SVProgressHUD.show()
    }
    
    public func hide() {
        SVProgressHUD.dismiss()
    }
    
    public func showError(_ error: Error) {
        showError(error.localizedDescription)
    }

    public func showError(_ message: String) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            guard let topView = UIApplication.shared.keyWindow?.subviews.last else { return }
            TopAlert(alertType: .error, title: message, inView: topView).show()
        }
    }
    
    public func showInfo(_ message: String) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            guard let topView = UIApplication.shared.keyWindow?.subviews.last else { return }
            TopAlert(alertType: .info, title: message, inView: topView).show()
        }
    }
    
    public func loaderScope(_ scope: () -> Void) {
        show()
        scope()
        hide()
    }
}
