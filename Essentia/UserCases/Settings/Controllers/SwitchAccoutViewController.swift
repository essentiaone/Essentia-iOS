//
//  SwitchAccoutViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 27.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class SwitchAccoutViewController: BaseBluredTableAdapterController {
    var users: [User] = []
    var callBack: () -> Void
    
    // MARK: - Dependences
    private lazy var userService: UserStorageServiceInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    
    init(_ callBack: @escaping () -> Void) {
        self.callBack = callBack
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - State
    
    private var state: [TableComponent] {
        return [
            .calculatbleSpace(background: .clear),
            .container(state: containerState),
            .empty(height: 18, background: .clear)]
    }
    
    private var containerState: [TableComponent] {
        let usersState = userService.get().map({ (user) -> [TableComponent] in
            return [.imageTitle(image: user.profile.icon, title: user.dislayName, withArrow: true, action: { [weak self] in
                        self?.loginToUser(user)
                    }),
                    .separator(inset: UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 0))]
        }).flatMap { return $0 }
        return [
               .empty(height: 10, background: .white),
               .titleWithCancel(title: LS("Settings.Accounts.Title"), action: cancelAction)]
               + usersState +
               [.imageTitle(image: imageProvider.plusIcon,
                            title: LS("Settings.Accounts.CreateNew"),
                        withArrow: false,
                           action: createUserAction),
                .empty(height: 10, background: .white)]
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableAdapter.hardReload(state)
    }
    
    // MARK: - Actions
    private lazy var cancelAction: () -> Void = { [weak self] in
        self?.dismiss(animated: true)
    }
    
    // MARK: - SwitchAccountTableAdapterDelegate
    func loginToUser(_ user: User) {
        dismiss(animated: true)
        EssentiaStore.shared.setUser(user)
        TabBarController.shared.selectedIndex = 0
        callBack()
    }
    
    private lazy var createUserAction: () -> Void = { [weak self] in
        self?.dismiss(animated: true)
        self?.generateNewUser()
    }
    
    private func generateNewUser() {
        EssentiaLoader.show {
            self.callBack()
        }
        (inject() as LoginInteractorInterface).generateNewUser {
            TabBarController.shared.selectedIndex = 0
        }
    }

}
