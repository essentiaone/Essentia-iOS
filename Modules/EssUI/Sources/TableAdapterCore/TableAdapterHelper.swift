//
//  TableAdapterHelper.swift
//  Essentia
//
//  Created by Pavlo Boiko on 16.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssDI
import EssResources

public class TableAdapterHelper {
    private weak var tableView: UITableView!
    public init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func heightForEmptySpace(with state: [TableComponent]) -> CGFloat {
        var totalContentHeight: CGFloat = 0
        for (index, item) in state.enumerated() {
            switch item {
            case .calculatbleSpace: fallthrough
            case .tableWithCalculatableSpace: fallthrough
            case .centeredImageWithCalculatableSpace: fallthrough
            case .centeredComponentTopInstet:
                break
            default:
                totalContentHeight += height(for: IndexPath(row: index, section: 0), in: state)
            }
        }
        let resultHeight = tableView.frame.height - totalContentHeight
        return resultHeight > 0.0 ? resultHeight : 0.0
    }
    #warning("Check tab bat size on X")
    func height(for indexPath: IndexPath, in state: [TableComponent]) -> CGFloat {
        let component = state[indexPath.row]
        switch component {
        case .separator:
            return 1.0
        case .shadow(let height, _, _):
            return height
        case .empty(let height, _):
            return height
        case .title(let bold, let title):
            let font = bold ? AppFont.bold : AppFont.regular
            return title.multyLineLabelHeight(with: font.withSize(34), width: tableView.frame.width)
        case .titleWithFont(let font, let title, _, _):
            return title.multyLineLabelHeight(with: font, width: tableView.frame.width)
        case .titleWithFontAligment(let font, let title, _, _):
            return title.multyLineLabelHeight(with: font, width: tableView.frame.width)
        case .descriptionWithSize(_, let fontSize, let title, _, _):
            return title.multyLineLabelHeight(with: AppFont.regular.withSize(fontSize), width: tableView.frame.width - 30) + 6
        case .description(let title, _):
            return title.multyLineLabelHeight(with: AppFont.regular.withSize(14.0), width: tableView.frame.width - 30) + 4
        case .tableWithHeight(let height, _):
            return height
        case .calculatbleSpace:
            return heightForEmptySpace(with: state)
        case .centeredImageWithCalculatableSpace:
            return heightForEmptySpace(with: state)
        case .accountStrength:
            return 286.0
        case .accountStrengthAction:
            return 394.0
        case .menuButton: fallthrough
        case .menuSwitch: fallthrough
        case .menuSimpleTitleDetail: fallthrough
        case .menuTitleDetail:
            return 44.0
        case .currentAccount:
            return 91.0
        case .checkBox:
            return 92.0
        case .pageControl:
            return 20
        case .smallCenteredButton: fallthrough
        case .actionCenteredButton: fallthrough
        case .centeredButton:
            return 75.0
        case .rightNavigationButton: fallthrough
        case .navigationImageBar: fallthrough
        case .navigationBar:
            return 44
        case .password(_, let withProgress, _):
            if withProgress {
                return 76.0
            }
            return 44.0
        case .paragraph(let title, let description):
            let labelWidth = tableView.frame.width - 43
            return title.multyLineLabelHeight(with: AppFont.bold.withSize(18),
                                              width: labelWidth) +
                description.multyLineLabelHeight(with: AppFont.regular.withSize(17),
                                                 width: labelWidth) + 20
        case .tabBarSpace:
//            return DeviceSeries.currentSeries == .iPhoneX ? 69.0 : 40.0
            return 40
        case .menuTitleCheck:
            return 44.0
        case .checkImageTitle: fallthrough
        case .imageUrlTitle: fallthrough
        case .imageTitle: fallthrough
        case .titleSubtitle: fallthrough
        case .assetBalance: fallthrough
        case .titleSubtitleDescription: fallthrough
        case .imageParagraph:
            return 60.0
        case .menuSectionHeader:
            return 26.0
        case .textField:
            return 35.0
        case .centeredImage(let image):
            return image.size.height
        case .centeredCorneredImageWithUrl(_, let size, _):
            return size.height
        case .centeredImageWithUrl(_, let size):
            return size.height
        case .textView:
            return 77.0
        case .twoButtons: fallthrough
        case .filledSegment:
            return 43.0
        case .customSegmentControlCell: fallthrough
        case .segmentControlCell:
            return 30.0
        case .search:
            return 36.0
        case .balanceChanging: fallthrough
        case .balanceChangingWithRank:
            return 25.0
        case .titleWithCancel:
            return 40.0
        case .transactionDetail:
            return 65.0
        case .searchField:
            return 42.0
        case .titleAttributedDetail:
            return 60.0
        case .slider:
            return 60.0
        case .attributedTitleDetail(let title, let detail, _):
            let titleHeight =  title.height(with: tableView.bounds.width)
            let detailHeight =  detail.height(with: tableView.bounds.width)
            return max(titleHeight, detailHeight) + 5
        case .textFieldTitleDetail:
            return 75.0
        case .titleCenteredDetail:
            return 44.0
        case  .titleCenteredDetailTextFildWithImage:
            return 44.0
        case .imageTitleSubtitle:
            return 96.0
        case .centeredImageButton(let image, _):
            return image.size.height + 25
        case .blure:
            return tableView.frame.height
        case .container(let state):
            return allContentHeight(for: state) + 20
        case .titleAction(let font, let title, _):
            return title.multyLineLabelHeight(with: font, width: tableView.frame.width - 30) + 4
        case .centeredComponentTopInstet:
            return heightForEmptySpace(with: state) / 2
        case .topAlert:
            return 0
        case .tableWithCalculatableSpace:
            return heightForEmptySpace(with: state)
        case .loader:
            return 40
        case .animation(_, let height):
            return height
        }
    }
    
    func allContentHeight(for state: [TableComponent]) -> CGFloat {
        var height: CGFloat = 0
        state.enumerated().forEach { (element) in
            height += self.height(for: IndexPath(row: element.offset, section: 0), in: state)
        }
        return height
    }
}
