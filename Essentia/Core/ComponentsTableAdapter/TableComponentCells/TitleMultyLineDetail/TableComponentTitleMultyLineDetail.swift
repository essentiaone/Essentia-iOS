//
//  TableComponentTitleMultyLineDetail.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/29/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static var horizontalInsets: CGFloat = 30
}

class TableComponentTitleMultyLineDetail: UITableViewCell, NibLoadable {
    private lazy var colorProvider: AppColorInterface = inject()
    
    @IBOutlet weak var titleLabel: UILabel!
    private var title: String = ""
    private var detail: String = ""
    private var action: (() -> Void)?
    
    func set(title: String, detail: String) {
        self.title = title
        self.detail = detail
        updateAttributedString()
    }
    
    private func updateAttributedString() {
        let mutableString = NSMutableAttributedString()
        let titleWithAttributes = attributedTitle(title: title)
        let titleWidth = titleWithAttributes.singleLineLabelWidth()
        mutableString.append(titleWithAttributes)
        mutableString.append(attributedDetail(titleWidth: titleWidth, detail: detail))
        titleLabel.attributedText = mutableString
    }
        
    func attributedTitle(title: String) -> NSAttributedString {
        return NSAttributedString(string: title + ": ", attributes: [NSAttributedString.Key.font: AppFont.medium.withSize(14),
                                                                              NSAttributedString.Key.foregroundColor: colorProvider.appDefaultTextColor])
    }
    
    func attributedDetail(titleWidth: CGFloat, detail: String) -> NSAttributedString {
        let fullDetail = NSMutableAttributedString()
        let detailString = NSAttributedString(string: detail, attributes: [NSAttributedString.Key.font: AppFont.medium.withSize(14),
                                                                           NSAttributedString.Key.foregroundColor: colorProvider.titleColor])
        let detailWidth = detailString.singleLineLabelWidth()
        let textWidth = titleWidth + detailWidth
        let labelWidth = self.titleLabel.frame.width - Constants.horizontalInsets
        if textWidth > labelWidth {
            fullDetail.append(NSAttributedString(string: "\n"))
        }
        fullDetail.append(detailString)
        
        return fullDetail
    }
    
    func cellHeght() -> CGFloat {
        updateAttributedString()
        return titleLabel.attributedText?.heightForLabel(width: self.titleLabel.frame.width) ?? 0
    }
}
