//
//  AnimatbleTableAdapterController.swift
//  EssUI
//
//  Created by user on 6/5/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import UIKit

open class AnimatbleTableAdapterController: BaseTableAdapterController {
    public var isAnimationShow: Bool = false
    
    public func showAnimation(_ delay: Double, execute: @escaping () -> Void) {
        tableAdapter.performTableUpdate(newState: state, withAnimation: .toTop)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [unowned self] in
            self.isAnimationShow.toggle()
            self.tableAdapter.performTableUpdate(newState: self.state, withAnimation: .toTop)
            self.tableView.isScrollEnabled = false
            execute()
        }
    }
}
