//
//  LaunchpadViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 08.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore

class LaunchpadViewController: BaseViewController, LaunchpadCollectionViewAdapterDelegate {
    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private lazy var colletionViewAdapter = LaunchpadCollectionViewAdapter(items: [],
                                                                           collectionView: collectionView)
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyDesign()
    }
    
    func applyDesign() {
        titleLabel.text = LS("TabBar.Launchpad")
        titleLabel.font = AppFont.bold.withSize(34)
        
        navigationController?.tabBarController?.tabBar.isHidden = false
        colletionViewAdapter.delegate = self
    }
    
    // MARK: - LaunchpadCollectionViewAdapterDelegate
    func didSelect(item: LaunchpadItemInterface) {
        navigationController?.tabBarController?.tabBar.isHidden = true
        item.show(from: self.navigationController!)
    }
    
    func willShowPage(at index: Int) {
        pageControl.currentPage = index
    }
}
