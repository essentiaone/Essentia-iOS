//
//  IconsAnimation.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/17/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class IconsAnimation {
    private var iconsPrefix: String
    private var framesCount: Int
    private var fps: Double
    
    init (iconsPrefix: String, framesCount: Int, fps: Double) {
        self.iconsPrefix = iconsPrefix
        self.framesCount = framesCount
        self.fps = fps
    }
    
    func showAnimationIn(imageView: UIImageView) {
        imageView.animationImages = images
        imageView.animationDuration = animationDuration
        imageView.animationRepeatCount = 1
        imageView.startAnimating()
    }
    
    var animationDuration: Double {
        return Double(framesCount) / fps
    }
    // MARK: - Private
    private var images: [UIImage] {
        return fileNames.compactMap({
            return UIImage(named: $0)
        })
    }
    
    private var fileNames: [String] {
        let names = [String](reserveCapacity: framesCount)
        return names.enumerated().map({ (name) -> String in
            return fileNameFor(index: name.offset)
        })
    }
    
    private func fileNameFor(index: Int) -> String {
        let zerosCount = maxDigitsInName - digitsInIndex(in: index)
        return iconsPrefix + String(repeating: "0", count: zerosCount) + index.string
    }
    
    private var maxDigitsInName: Int {
        return digitsInIndex(in: framesCount)
    }
    
    private func digitsInIndex(in index: Int) -> Int {
        return "\(index)".count
    }
}
