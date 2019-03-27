//
//  TableComponentSearch.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssDI

class TableComponentSearch: UITableViewCell, NibLoadable, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var textChangedAction: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        searchBar.delegate = self
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textChangedAction?(searchText)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.isUserInteractionEnabled = true
    }
}
