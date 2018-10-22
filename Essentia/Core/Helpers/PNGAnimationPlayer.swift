//
//  PNGAnimationPlayer.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/22/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

enum PNGAnimation: String {
    case exchange
    case exchangeEss
    case securing0to30
    case securing30to70
    case securing70to99
    case securing99toSafe
    case sendTx
    
    var animationDuration: TimeInterval {
        return Double(imagesCount) / Double(framePerSecond)
    }
    
    var images: [UIImage] {
        let numberFormatter = ConstantNumberOfDigitsFormatter(digitsCount: 5)
        return imagesRage.compactMap({
            let name = imagePrefix + " " + numberFormatter.formateInt(int: $0)
            return UIImage(named: name)
        })
    }
    
    // MARK: - Private
    private var imagePrefix: String {
        return rawValue.firstSimbolUppercased()
    }
    
    private var imagesRage: Range<Int> {
        switch self {
        case .exchange: fallthrough
        case .exchangeEss:
            return 0..<113
        case .securing0to30: fallthrough
        case .securing30to70: fallthrough
        case .securing70to99:
            return 30..<61
        case .sendTx:
            return 0..<120
        case .securing99toSafe:
            return 0..<210
        }
    }
    
    private var imagesCount: Int {
        return imagesRage.count
    }
    
    private var framePerSecond: Int {
        switch self {
        case .securing99toSafe:
            return 30
        default:
            return 60
        }
    }
}

class PNGAnimationPlayer {
    private var animation: PNGAnimation
    private var imageView: UIImageView
    
    init(animation: PNGAnimation, in imageView: UIImageView) {
        self.animation = animation
        self.imageView = imageView
    }
    
    func play() {
        imageView.animationImages = animation.images
        imageView.animationDuration = animation.animationDuration
        imageView.image = imageView.animationImages?.last
        imageView.animationRepeatCount = 1
        imageView.startAnimating()
    }
}
