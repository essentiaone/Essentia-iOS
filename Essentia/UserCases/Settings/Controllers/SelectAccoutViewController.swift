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

class SelectAccoutViewController: BaseBluredTableAdapterController {
    var users: [User] = []
    weak var delegate: SelectAccountDelegate?
    
    // MARK: - Dependences
    private lazy var userService: UserStorageServiceInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    
    init(_ delegate: SelectAccountDelegate) {
        self.delegate = delegate
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
            return [.imageTitle(image: user.profile.icon, title: user.dislayName, withArrow: true, action: { [unowned self] in
                        self.dismiss(animated: true)
                        self.delegate?.didSelectUser(user)
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
    private lazy var cancelAction: () -> Void = { [unowned self] in
        self.dismiss(animated: true)
    }
    
    private lazy var createUserAction: () -> Void = { [unowned self] in
        self.dismiss(animated: true)
        self.delegate?.createNewUser()
    }

}
