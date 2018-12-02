//
//  EssentiaLoader.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/22/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class EssentiaLoader {
    static func show(callBack: @escaping () -> Void) {
        let contentView = UIView(frame: UIScreen.main.bounds)
        contentView.backgroundColor = .white
        let imageView = UIImageView(frame: contentView.frame)
        imageView.contentMode = .center
        contentView.addSubview(imageView)
        contentView.layer.opacity = 0
        UIApplication.shared.keyWindow?.addSubview(contentView)
        let player = PNGAnimationPlayer(animation: .preLoader, in: imageView)
        UIView.animate(withDuration: 0.3, animations: {
            contentView.layer.opacity = 1
        }, completion: { _ in
            player.play()
        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + player.animation.animationDuration + 0.3) {
            UIView.animate(withDuration: 0.3, animations: {
                contentView.layer.opacity = 0
            }, completion: { _ in
                callBack()
                contentView.removeFromSuperview()
            })
        }
    }
}
