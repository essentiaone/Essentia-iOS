//
//  SelectAccoutViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 27.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssModel
import EssResources
import EssUI
import EssDI
import Crashlytics

class SelectAccoutViewController: BaseTableAdapterController {
    var users: [User] = []
    weak var delegate: SelectAccountDelegate?
    
    // MARK: - Dependences
    private lazy var userService: ViewUserStorageServiceInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var viewUserService: ViewUserStorageServiceInterface = inject()
    
    init(_ delegate: SelectAccountDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - State
    
    override var state: [TableComponent] {
        let users = userService.users
        logAccountsCount(usersCount: users.count)
        let usersState = users |> viewUserState |> concat
        return [
            .empty(height: 35, background: colorProvider.settingsCellsBackround),
            .navigationBar(left: LS("EditAccount.Back"),
                           right: LS("Settings.Accounts.Edit"),
                           title: LS("Settings.Accounts.Title"),
                           lAction: cancelAction,
                           rAction: editAction)]
            + usersState +
            [.imageTitle(image: imageProvider.plusIcon,
                         title: LS("Settings.Accounts.CreateNew"),
                         withArrow: false,
                         action: createUserAction),
             .empty(height: 10, background: colorProvider.appBackgroundColor)]
    }
    
    func viewUserState(_ user: ViewUser) -> [TableComponent] {
        let icon = AvatarHashView(hash: user.id, frame: CGRect(x: 0, y: 0, width: 40, height: 40)).image
        return
            [.imageTitle(image: icon, title: user.name, withArrow: true, action: { [unowned self] in
                self.dismiss(animated: true)
                self.delegate?.didSelectUser(user)
            }),
             .separator(inset: UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 0))]
    }
    
    // MARK: - Actions
    private lazy var editAction: () -> Void = { [unowned self] in
        self.present(DeleteAccountViewController(deletedAction: { userId in
            self.dismiss(animated: true, completion: {
                self.delegate?.didDelete(userId: userId)
            })
        }), animated: true)
    }
    
    private lazy var createUserAction: () -> Void = { [unowned self] in
        self.dismiss(animated: true)
        self.delegate?.createNewUser()
    }
    
    private lazy var cancelAction: () -> Void = { [unowned self] in
        self.dismiss(animated: true)
    }
    
    // MARK: - Analitics
    
    private func logAccountsCount(usersCount: Int) {
        Answers.logCustomEvent(withName: "AccountsCount", customAttributes: ["count": usersCount])
    }
}
