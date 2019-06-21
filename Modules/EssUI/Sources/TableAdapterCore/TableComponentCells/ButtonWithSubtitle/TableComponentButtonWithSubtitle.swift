//
//  TableComponentButtonWithSubtitle.swift
//  EssUI
//
//  Created by Pavlo Boiko on 5/21/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import UIKit
import EssDI
import EssResources

class TableComponentButtonWithSubtitle: UITableViewCell, NibLoadable {
    private lazy var colorProvider: AppColorInterface = inject()
    
    @IBOutlet weak var titleButton: UIButton!
    
    var action: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        titleButton.layer.cornerRadius = 4
        titleButton.titleLabel?.numberOfLines = 2
        titleButton.titleLabel?.textAlignment = .center
    }
    
    func set(title: String, subtitle: String) {
        let attributedText = NSMutableAttributedString()
        attributedText.append(NSAttributedString(string: title,
                                                 attributes: [.font: AppFont.bold.withSize(15)]))
        attributedText.append(NSAttributedString(string: "\n"))
        attributedText.append(NSAttributedString(string: subtitle,
                                                     attributes: [.font: AppFont.light.withSize(15)]))
        attributedText.addAttributes([.foregroundColor: colorProvider.appBackgroundColor.cgColor],
                                     range: NSRange(location: 0, length: attributedText.length))
        titleButton.setAttributedTitle(attributedText, for: .normal)
    }
    
    @IBAction func action(_ sender: Any) {
        self.action?()
    }
}
