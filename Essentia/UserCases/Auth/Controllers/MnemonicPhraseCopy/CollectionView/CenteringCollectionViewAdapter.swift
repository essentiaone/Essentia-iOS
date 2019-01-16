//
//  CenteringCollectionViewAdapter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 20.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssResources

fileprivate struct Constants {
    static var cellHeight: CGFloat = 30
    static var cellTextInset: CGFloat = 12
    static var cellFont: UIFont = AppFont.medium.withSize(16)
}

class CenteringCollectionViewAdapter: NSObject,
                                      UICollectionViewDataSource,
                                      UICollectionViewDelegate,
                                      UICollectionViewDelegateFlowLayout {
    // MARK: - Store
    let elemets: [String]
    let collectionView: UICollectionView
    
    // MARK: - Init
    init(components: String, in collectionView: UICollectionView) {
        self.elemets = components.components(separatedBy: " ")
        self.collectionView = collectionView
        super.init()
        setupCollectionView()
    }
    
    func loadCollection() {
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BorderedCell.self)
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView
        (
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        let cell: BorderedCell = collectionView.dequeueReusableCell(at: indexPath)
        cell.titleLabel.text = elemets[indexPath.item]
        cell.titleLabel.font = AppFont.medium.withSize(16)
        return cell
    }
    
    func collectionView
        (
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int {
        return elemets.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
        let currentString = elemets[indexPath.item]
        let textWidth = currentString.singleLineLabelWidth(with: Constants.cellFont)
        return CGSize(width: textWidth + Constants.cellTextInset,
                      height: Constants.cellHeight)
    }
    
}
