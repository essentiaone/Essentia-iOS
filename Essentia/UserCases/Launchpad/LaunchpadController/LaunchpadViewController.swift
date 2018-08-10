//
//  LaunchpadViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 08.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class LaunchpadViewController: BaseViewController, LaunchpadCollectionViewAdapterDelegate {
    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private lazy var colletionViewAdapter = LaunchpadCollectionViewAdapter(items: [TestItem()],
                                                                           collectionView: collectionView)
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyDesign()
    }
    
    func applyDesign() {
        titleLabel.text = LS("TabBar.Launchpad")
        titleLabel.font = AppFont.bold.withSize(36)
        
        colletionViewAdapter.delegate = self
    }
    
    // MARK: - LaunchpadCollectionViewAdapterDelegate
    func didSelect(item: LaunchpadItemInterface) {
        item.show(from: self)
    }
    
    func willShowPage(at index: Int) {
        pageControl.currentPage = index
    }
}
