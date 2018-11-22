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
    case preLoader
    case sendTx
    
    private static var indexFormatter = ConstantNumberOfDigitsFormatter(digitsCount: 5)
    
    var animationDuration: TimeInterval {
        return Double(imagesCount) / Double(framePerSecond)
    }
    
    var images: [UIImage] {
        return imagesRage.compactMap({
            return imageAtIndex(index: $0)
        })
    }
    
    func imageAtIndex(index: Int) -> UIImage? {
        let name = imagePrefix + " " + PNGAnimation.indexFormatter.formateInt(int: index)
        return UIImage(named: name)
    }
    
    var imagesRage: Range<Int> {
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
        case .preLoader:
            return 0..<89
        }
    }
    
    // MARK: - Private
    private var imagePrefix: String {
        return rawValue.firstSimbolUppercased()
    }
    
    private var imagesCount: Int {
        return imagesRage.count
    }
    
    private var framePerSecond: Int {
        switch self {
        case .preLoader: fallthrough
        case .securing99toSafe:
            return 30
        default:
            return 60
        }
    }
}

class PNGAnimationPlayer {
    var animation: PNGAnimation
    private var imageView: UIImageView
    
    init(animation: PNGAnimation, in imageView: UIImageView) {
        self.animation = animation
        self.imageView = imageView
    }
    
    var firstImage: UIImage? {
        let index = animation.imagesRage.first ?? 0
        return animation.imageAtIndex(index: index)
    }
    
    var lastImage: UIImage? {
        let index = animation.imagesRage.last ?? 0
        return animation.imageAtIndex(index: index)
    }
    
    func play() {
        imageView.animationImages = animation.images
        imageView.animationDuration = animation.animationDuration
        imageView.image = imageView.animationImages?.last
        imageView.animationRepeatCount = 1
        imageView.startAnimating()
    }
}
