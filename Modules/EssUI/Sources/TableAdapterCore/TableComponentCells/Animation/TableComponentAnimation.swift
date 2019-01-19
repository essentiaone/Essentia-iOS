//
//  TableComponentAnimation.swift
//  EssUI
//
//  Created by Pavlo Boiko on 1/17/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation
import EssCore
import EssResources

class TableComponentAnimation: UITableViewCell, NibLoadable {
    @IBOutlet weak var animateImageView: UIImageView!
    
    func playAnimation(_ animation: PNGAnimation) {
        let player = PNGAnimationPlayer(animation: animation, in: animateImageView)
        player.play()
    }

}
