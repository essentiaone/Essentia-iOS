//
//  CenteringLayout.swift
//  Essentia
//
//  Created by Pavlo Boiko on 21.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static var leftPadding: CGFloat = 8
}

fileprivate enum LayoutAttributesType {
    case left
    case right
}

class CenterAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = layoutAttributes(in:rect)
        let interItemSpacing = minimumInteritemSpacing
        var rowSizes: [[CGFloat]] = []
        
        func calculateInset
            (
            with attributs: [UICollectionViewLayoutAttributes],
            type: LayoutAttributesType
            ) {
            var leftMargin: CGFloat = Constants.leftPadding
            var maxY: CGFloat = -1.0
            var currentRow: Int = 0
            
            func applyLayoutAttributs(_ attributes: UICollectionViewLayoutAttributes) {
                attributes.frame.origin.x = leftMargin
                leftMargin += attributes.frame.width + interItemSpacing
                maxY = max(attributes.frame.maxY, maxY)
            }
            
            let leftIsentsBlock: (UICollectionViewLayoutAttributes) -> Void = { layoutAttribute  in
                let isMaxY = layoutAttribute.frame.origin.y >= maxY
                if isMaxY {
                    leftMargin = Constants.leftPadding
                    let rowWidth = rowSizes[currentRow][1] - rowSizes[currentRow][0]
                    let collectionViewWidth = self.collectionView?.frame.width ?? 0
                    let appendedMargin = (collectionViewWidth - Constants.leftPadding * 2 - rowWidth) / 2
                    leftMargin += appendedMargin
                    currentRow += 1
                }
                applyLayoutAttributs(layoutAttribute)
            }
            
            let rightIsentsBlock: (UICollectionViewLayoutAttributes) -> Void = { layoutAttribute  in
                let isMaxY = layoutAttribute.frame.origin.y >= maxY
                if isMaxY {
                    leftMargin = Constants.leftPadding
                    if rowSizes.isEmpty {
                        rowSizes = [[leftMargin, 0]]
                    } else {
                        rowSizes.append([leftMargin, 0])
                        currentRow += 1
                    }
                }
                applyLayoutAttributs(layoutAttribute)
                rowSizes[currentRow][1] = leftMargin - interItemSpacing
            }
            
            switch type {
            case .left:
                attributes.forEach(leftIsentsBlock)
            case .right:
                attributes.forEach(rightIsentsBlock)
            }
        }
        
        calculateInset(with: attributes, type: .left)
        calculateInset(with: attributes, type: .right)
        
        return attributes
    }
    
    func layoutAttributes(in rect: CGRect) -> [UICollectionViewLayoutAttributes] {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes] else {
                return [UICollectionViewLayoutAttributes]()
        }
        return attributes
    }
}
