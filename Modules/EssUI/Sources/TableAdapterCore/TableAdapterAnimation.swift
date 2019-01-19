//
//  TableAdapterUpdateAnimation.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/14/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

public enum TableAdapterAnimation {
    case none
    case toRight
    case toLeft
    case toTop
    
    func insertAnimation(_ component: TableComponent) -> UITableView.RowAnimation {
        guard canAnimation(component) else { return .none }
        switch self {
        case .none:
            return .none
        case .toLeft:
            return .left
        case .toRight:
            return .right
        case .toTop:
            return .bottom
        }
    }
    
    func deleteAnimation(_ component: TableComponent) -> UITableView.RowAnimation {
        guard canAnimation(component) else { return .none }
        switch self {
        case .none:
            return .none
        case .toLeft:
            return .right
        case .toRight:
            return .left
        case .toTop:
            return .bottom  
        }
    }
    
    func canAnimation(_ component: TableComponent) -> Bool {
        switch component {
        case .pageControl:
            return false
        default:
            return true
        }
    }
}
