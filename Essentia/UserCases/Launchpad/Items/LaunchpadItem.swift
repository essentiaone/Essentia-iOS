//
//  LaunchpadItem.swift
//  Essentia
//
//  Created by Pavlo Boiko on 08.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

protocol LaunchpadItemInterface {
    var title: String { get }
    var subTitle: String { get }
    var icon: UIImage { get }
    func show(from rootController: UIViewController)
}

class TestItem: LaunchpadItemInterface {
    var title: String = "Title"
    
    var subTitle: String = "Subtitle"
    
    var icon: UIImage = #imageLiteral(resourceName: "InfoCheckIcon")
    
    func show(from rootController: UIViewController) {
        
    }
}
