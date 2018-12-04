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
    @IBOutlet weak var titleLabel: UILabel!
    private var action: (() -> Void)?
    
    func set(title: String, detail: String, width: CGFloat) {
        self.titleLabel.attributedText = TableComponentTitleMultyLineDetail.attributedString(title: title, detail: detail, width: width)
    }
    
    private static func attributedString(title: String, detail: String, width: CGFloat) -> NSAttributedString {
        let mutableString = NSMutableAttributedString()
        let titleWithAttributes = attributedTitle(title: title)
        let titleWidth = titleWithAttributes.singleLineLabelWidth()
        mutableString.append(titleWithAttributes)
        mutableString.append(attributedDetail(titleWidth: titleWidth, detail: detail, width: width))
        return mutableString
    }
        
    private static func attributedTitle(title: String) -> NSAttributedString {
        return NSAttributedString(string: title + ": ", attributes: [NSAttributedString.Key.font: AppFont.medium.withSize(14),
                                                                              NSAttributedString.Key.foregroundColor: (inject() as AppColorInterface).appDefaultTextColor])
    }
    
    private static func attributedDetail(titleWidth: CGFloat, detail: String, width: CGFloat) -> NSAttributedString {
        let fullDetail = NSMutableAttributedString()
        let detailString = NSAttributedString(string: detail, attributes: [NSAttributedString.Key.font: AppFont.medium.withSize(14),
                                                                           NSAttributedString.Key.foregroundColor: (inject() as AppColorInterface).titleColor])
        let detailWidth = detailString.singleLineLabelWidth()
        let textWidth = titleWidth + detailWidth
        let labelWidth = width - Constants.horizontalInsets
        if textWidth > labelWidth {
            fullDetail.append(NSAttributedString(string: "\n"))
        }
        fullDetail.append(detailString)
        return fullDetail
    }
    
    static func cellHeght(title: String, detail: String, width: CGFloat) -> CGFloat {
        return attributedString(title: title, detail: detail, width: width).heightForLabel(width: width)
    }
}
