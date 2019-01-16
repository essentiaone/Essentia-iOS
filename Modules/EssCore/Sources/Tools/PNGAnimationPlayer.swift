//
//  PNGAnimationPlayer.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/22/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssResources

public enum PNGAnimation: String {
    case exchange
    case exchangeEss
    case securing0to30
    case securing30to70
    case securing70to99
    case securing99toSafe
    case preLoader
    case sendTx
    
    private static var indexFormatter = ConstantNumberOfDigitsFormatter(digitsCount: 5)
    
    public var animationDuration: TimeInterval {
        return Double(imagesCount) / Double(framePerSecond)
    }
    
    public var images: [UIImage] {
        return imagesRage.compactMap({
            return imageAtIndex(index: $0)
        })
    }
    
    public func imageAtIndex(index: Int) -> UIImage? {
        let name = imagePrefix + " " + PNGAnimation.indexFormatter.formateInt(int: index)
        return AppImageProvider.image(name: name)
    }
    
    public var imagesRage: Range<Int> {
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

public class PNGAnimationPlayer {
    public var animation: PNGAnimation
    private var imageView: UIImageView
    
    public init(animation: PNGAnimation, in imageView: UIImageView) {
        self.animation = animation
        self.imageView = imageView
    }
    
    public var firstImage: UIImage? {
        let index = animation.imagesRage.first ?? 0
        return animation.imageAtIndex(index: index)
    }
    
    public var lastImage: UIImage? {
        let index = animation.imagesRage.last ?? 0
        return animation.imageAtIndex(index: index)
    }
    
    public func play() {
        imageView.animationImages = animation.images
        imageView.animationDuration = animation.animationDuration
        imageView.image = imageView.animationImages?.last
        imageView.animationRepeatCount = 1
        imageView.startAnimating()
    }
}
