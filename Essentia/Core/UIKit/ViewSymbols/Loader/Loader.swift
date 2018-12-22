//
//  Loader.swift
//  Essentia
//
//  Created by Pavlo Boiko on 27.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import SVProgressHUD
import EssentiaNetworkCore

class Loader: LoaderInterface {
    init() {
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setDefaultMaskType(.black)
    }
    
    func show() {
        SVProgressHUD.show()
        (inject() as LoggerServiceInterface).log("Loader showd")
    }
    
    func hide() {
        SVProgressHUD.dismiss()
        (inject() as LoggerServiceInterface).log("Loader hidden")
    }
    
    func showError(_ error: Error) {
        switch error {
        case let essError as EssentiaError:
            showError(essError.localizedDescription)
        case let networkError as EssentiaNetworkError:
            showError(networkError.localizedDescription)
        default:
            showError(EssentiaError.unknownError.localizedDescription)
        }
    }
    
    func showError(_ message: String) {
        guard let topView = UIApplication.shared.keyWindow?.subviews.last else { return }
        TopAlert(alertType: .error, title: message, inView: topView).show()
    }
    
    func loaderScope(_ scope: () -> Void) {
        show()
        scope()
        hide()
    }
}
