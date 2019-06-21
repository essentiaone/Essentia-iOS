//
//  SelectAccountToPurchaseViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 5/22/19.
//  Copyright © 2019 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssModel
import EssResources
import EssUI
import EssDI

class SelectAccountToPurchaseViewController: BaseBluredTableAdapterController {
    // MARK: - Dependences
    private lazy var userService: ViewUserStorageServiceInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()
    
    private var userAction: ((ViewUser) -> Void)?
    
    init(_ userAction: @escaping (ViewUser) -> Void) {
        self.userAction = userAction
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - State
    
    override var state: [TableComponent] {
        return [
            .calculatbleSpace(background: .clear),
            .container(state: containerState),
            .empty(height: 18, background: .clear)]
    }
    
    private var containerState: [TableComponent] {
        let usersState = userService.users |> viewUserState |> concat
        return [
            .empty(height: 10, background: colorProvider.appBackgroundColor),
            .titleWithCancel(title: LS("Settings.Accounts.Title"), action: cancelAction)]
            + usersState +
             [.empty(height: 10, background: colorProvider.appBackgroundColor)]
    }
    
    func viewUserState(_ user: ViewUser) -> [TableComponent] {
        let icon = AvatarHashView(hash: user.id, frame: CGRect(x: 0, y: 0, width: 40, height: 40)).image
        return
            [.imageTitle(image: icon, title: user.name, withArrow: true, action: { [unowned self] in
                self.dismiss(animated: true)
                self.userAction?(user)
            }),
             .separator(inset: UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 0))]
    }
    
    // MARK: - Actions
    private lazy var cancelAction: () -> Void = { [unowned self] in
        self.dismiss(animated: true)
    }
}
