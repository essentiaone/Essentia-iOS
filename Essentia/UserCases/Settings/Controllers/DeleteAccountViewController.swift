//
//  DeleteAccountViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 6/26/19.
//  Copyright © 2019 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssModel
import EssResources
import EssUI
import EssDI
import Crashlytics

class DeleteAccountViewController: BaseBluredTableAdapterController {
    var users: [User] = []
    var deletedAction: () -> Void
    
    // MARK: - Dependences
    private lazy var userService: ViewUserStorageServiceInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var viewUserService: ViewUserStorageServiceInterface = inject()
    
    init(deletedAction: @escaping () -> Void) {
        self.deletedAction = deletedAction
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
        let users = userService.users
        let usersState = users |> viewUserState |> concat
        return [
            .empty(height: 10, background: colorProvider.appBackgroundColor),
            .titleWithDetailAction(title:  LS("Settings.Accounts.Title"), detailTitle: LS("Settings.Accounts.Cancel"), action: cancelAction)]
            + usersState
    }
    
    func viewUserState(_ user: ViewUser) -> [TableComponent] {
        let icon = AvatarHashView(hash: user.id, frame: CGRect(x: 0, y: 0, width: 40, height: 40)).image
        return
            [.imageTitle(image: icon, title: user.name, withArrow: true, action: { [unowned self] in
                self.checkLoginToUser(user)
            }),
             .separator(inset: UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 0))]
    }
    
    private func checkLoginToUser(_ user: ViewUser) {
        let loginVc = LoginPasswordViewController(userId: user.id, hash: user.passwordHash, password: { _ in
            self.dismiss(animated: true)
            self.present(DeleteAccountAlertViewController(leftAction: {
                 self.viewUserService.remove(user)
                self.dismiss(animated: true, completion: {
                    self.deletedAction()
                })
            }, rightAction: {
                self.dismiss(animated: true)
            }), animated: true)
        }, cancel: {
            self.dismiss(animated: true)
        })
        present(loginVc, animated: true)
    }
    
    // MARK: - Actions
    private lazy var cancelAction: () -> Void = { [unowned self] in
        self.dismiss(animated: true)
    }
}
