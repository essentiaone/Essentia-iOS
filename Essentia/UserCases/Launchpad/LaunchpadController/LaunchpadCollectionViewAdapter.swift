//
//  LaunchpadCollectionViewAdapter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 09.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static var cellsPerRow: Int = 3
    static var cellsPerColumn: Int = 3
    static var cellsInset: CGFloat = 60
    static var horizontalInsets: CGFloat = 30
}

protocol LaunchpadCollectionViewAdapterDelegate: class {
    func willShowPage(at index: Int)
    func didSelect(item: LaunchpadItemInterface)
}

class LaunchpadCollectionViewAdapter: NSObject,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    weak var delegate: LaunchpadCollectionViewAdapterDelegate?
    let items: [LaunchpadItemInterface]
    let collectionView: UICollectionView
    
    init(items: [LaunchpadItemInterface], collectionView: UICollectionView) {
        self.items = items
        self.collectionView = collectionView
        super.init()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LaunchpadItemCell.self)
        collectionView.reloadData()
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LaunchpadItemCell = collectionView.dequeueReusableCell(at: indexPath)
        let item = items[indexPath.item]
        cell.titleLabel.text = item.title
        cell.subtitleLabel.text = item.subTitle
        cell.imageView.image = item.icon
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        delegate?.didSelect(item: item)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 134)
    }
}
