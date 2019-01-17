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
import EssCore
import EssModel

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
        switch error {
        case let essError as EssentiaError:
            showError(essError.localizedDescription)
        case let networkError as EssentiaNetworkError:
            showError(networkError.localizedDescription)
        default:
            showError(EssentiaError.unknownError.localizedDescription)
        }
    }
    
    public func showError(_ message: String) {
        guard let topView = UIApplication.shared.keyWindow?.subviews.last else { return }
        TopAlert(alertType: .error, title: message, inView: topView).show()
    }
    
    public func loaderScope(_ scope: () -> Void) {
        show()
        scope()
        hide()
    }
}
