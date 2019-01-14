//
//  PharaseConfirmeCollectionViewAdapter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 23.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore

fileprivate struct Constants {
    static var cellInset: CGFloat = 18
    static var cellHeight: CGFloat = 26
}

class PhraseConfirmCollectionViewAdapter: NSObject,
    UICollectionViewDataSource,
    PhraseEnteringViewProtocol,
UICollectionViewDelegateFlowLayout {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    
    // MARK: - Store
    var state: [PhraseEnteringState] = []
    weak var collectionView: UICollectionView?
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        setupCollectionView(collectionView)
    }
    
    func updateState(state: [PhraseEnteringState]) {
        let filtered: [PhraseEnteringState] = state.filter {
            return $0 != PhraseEnteringState.empty
        }
        let sorted = filtered.sorted {
            return $0.sortValue < $1.sortValue
        }
        self.state = sorted
        collectionView?.reloadData()
    }
    
    private func setupCollectionView(_ collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EditingCell.self)
        collectionView.register(BorderedCell.self)
    }
    
    // MARK: - UICollectionViewDataSour
    func collectionView
        (
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        switch state[indexPath.item] {
        case .entered(let string, _):
            let cell: BorderedCell = collectionView.dequeueReusableCell(at: indexPath)
            cell.titleLabel.textColor = colorProvider.enteredWordText
            cell.titleLabel.backgroundColor = colorProvider.enteredWordBackgroud
            cell.titleLabel.text = string
            return cell
        case .entering(let word, let placeholder, _):
            let cell: EditingCell = collectionView.dequeueReusableCell(at: indexPath)
            cell.setTitle(string: word, placeholder: placeholder)
            return cell
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return state.count
    }
    
    func collectionView
        (
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
        switch state[indexPath.item] {
        case .entered(let string, _):
            let textWidth = string.singleLineLabelWidth(with: AppFont.medium.withSize(15))
            return CGSize(width: textWidth + Constants.cellInset,
                          height: Constants.cellHeight)
        case .entering(let word, let placeholder, _):
            let textWidth = (word + placeholder).singleLineLabelWidth(with: AppFont.medium.withSize(15))
            return CGSize(width: textWidth + Constants.cellInset ,
                          height: Constants.cellHeight)
        default:
            fatalError()
        }
    }
    
}
