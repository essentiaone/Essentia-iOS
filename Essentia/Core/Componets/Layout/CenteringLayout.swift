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
    var rowSizes: [[CGFloat]] = []
    
    var interItemSpacing: CGFloat {
        return minimumLineSpacing
    }

    override func layoutAttributesForElements
        (
        in rect: CGRect
        ) -> [UICollectionViewLayoutAttributes]? {
        let attributes = layoutAttributes(in:rect)
        
        calculateInset(with: attributes, type: .right)
        calculateInset(with: attributes, type: .left)
        
        return attributes
    }
    
    private func calculateInset
        (
        with attributes: [UICollectionViewLayoutAttributes],
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
                let rowWidth = self.rowSizes[currentRow][1] - self.rowSizes[currentRow][0]
                let collectionViewWidth = self.collectionView?.frame.width ?? 0
                let appendedMargin = (collectionViewWidth - Constants.leftPadding * 2 - rowWidth) / 2
                leftMargin += appendedMargin
                currentRow++
            }
            applyLayoutAttributs(layoutAttribute)
        }
        let rightIsentsBlock: (UICollectionViewLayoutAttributes) -> Void = { layoutAttribute  in
            let isMaxY = layoutAttribute.frame.origin.y >= maxY
            if isMaxY {
                leftMargin = Constants.leftPadding
                if self.rowSizes.isEmpty {
                    self.rowSizes = [[leftMargin, 0]]
                } else {
                    self.rowSizes.append([leftMargin, 0])
                    currentRow++
                }
            }
            applyLayoutAttributs(layoutAttribute)
            self.rowSizes[currentRow][1] = leftMargin - self.interItemSpacing
        }
        
        switch type {
        case .left:
            attributes.forEach(leftIsentsBlock)
        case .right:
            attributes.forEach(rightIsentsBlock)
        }
    }
    
    func layoutAttributes(in rect: CGRect) -> [UICollectionViewLayoutAttributes] {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
        let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes] else {
                return [UICollectionViewLayoutAttributes]()
        }
        return attributes
    }
}
