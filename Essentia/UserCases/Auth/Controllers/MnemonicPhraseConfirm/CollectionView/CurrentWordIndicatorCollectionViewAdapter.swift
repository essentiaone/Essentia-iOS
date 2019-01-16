//
//  CurrentWordIndicatorCollectionViewAdapter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 24.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssResources

fileprivate struct Constans {
    static var cellInset: CGFloat = 5.0
}

class CurrentWordIndicatorAdapter: NSObject,
                                                 UICollectionViewDataSource,
                                                 UICollectionViewDelegateFlowLayout,
                                                 PhraseEnteringViewProtocol {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    
    // MARK: - Store
    var state: [PhraseEnteringState] = []
    weak var collectionView: UICollectionView?
    
    // MARK: - Init
    init(collectionView: UICollectionView) {
        super.init()
        setupCollectionView(collectionView)
        self.collectionView = collectionView
    }
    
    func updateState(state: [PhraseEnteringState]) {
        self.state = state
        collectionView?.reloadData()
    }
    
    // MARK: - Private
    private func setupCollectionView(_ collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self)
    }
    
    private func color(for indexPath: IndexPath) -> UIColor {
        switch state[indexPath.item] {
        case .empty:
            return colorProvider.currentWordEmpty
        case .entered:
            return colorProvider.currentWordSelected
        case .entering:
            return colorProvider.currentWordCurrent
        }
    }
    
    // MARK: - UICollectionViewDataSourse
    func collectionView
        (
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(at: indexPath)
        cell.layer.cornerRadius = cell.frame.height / 2
        cell.backgroundColor = color(for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return state.count
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView
        (
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
        let allInsetsWidth: CGFloat = CGFloat(state.count - 1) * Constans.cellInset
        let allCellsWidth: CGFloat = collectionView.frame.width - allInsetsWidth
        let widthPerCell: CGFloat = allCellsWidth / CGFloat(state.count)
        return CGSize(width: widthPerCell, height: collectionView.frame.height)
    }
    
    func collectionView
        (
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
        ) -> CGFloat {
        return Constans.cellInset
    }
}
