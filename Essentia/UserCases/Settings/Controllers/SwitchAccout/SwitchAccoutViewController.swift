//
//  SwitchAccoutViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 27.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class SwitchAccoutViewController: BaseViewController {
    @IBOutlet weak var accountsTableview: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    var users: [User] = []
    var callBack: () -> Void
    
    // MARK: - Dependences
    private lazy var userService: UserStorageServiceInterface = inject()
    private lazy var tableAdapter = TableAdapter(tableView: accountsTableview)
    private lazy var imageProvider: AppImageProviderInterface = inject()
    
    init(_ callBack: @escaping () -> Void) {
        self.callBack = callBack
        super.init()
        modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - State
    
    private var state: [TableComponent] {
        let usersState = users.map({ (user) -> [TableComponent] in
            return [.imageTitle(image: user.profile.icon, title: user.dislayName, withArrow: true, action: {
                        self.loginToUser(user)
                    }),
                    .separator(inset: UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 0))]
        }).flatMap {
            return $0
        }
        return usersState + [.imageTitle(image: imageProvider.plusIcon,
                                         title: LS("Settings.Accounts.CreateNew"),
                                         withArrow: false,
                                         action: createUserAction)]
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers()
        applyDesign()
        tableAdapter.reload(state)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setContentTopInset()
    }
    
    // MARK: - Actions
    @IBAction func cancelAction(_ sender: AnyObject) {
        callBack()
        dismiss(animated: true)
    }
    
    private func setContentTopInset() {
        let staticContentHeight: CGFloat = 150.0
        let singeCellHeight: CGFloat = 61.0
        let dynamicContentHeight = singeCellHeight * CGFloat(users.count)
        let allContentHeight = staticContentHeight + dynamicContentHeight
        containerHeight.constant = allContentHeight
    }
    
    private func loadUsers() {
        let users = userService.get()
        self.users = users
    }
    
    private func applyDesign() {
        contentView.layer.cornerRadius = 10.0
        titleLabel.text = LS("Settings.Accounts.Title")
        titleLabel.font = AppFont.bold.withSize(21)
        cancelButton.setImage(imageProvider.cancelIcon, for: .normal)
    }
    
    // MARK: - SwitchAccountTableAdapterDelegate
    func loginToUser(_ user: User) {
        dismiss(animated: true)
        EssentiaStore.currentUser = user
        callBack()
    }
    
    private lazy var createUserAction: () -> Void = { [weak self] in
        self?.dismiss(animated: true)
        self?.generateNewUser()
        self?.callBack()
    }
    
    private func generateNewUser() {
        (inject() as LoaderInterface).show()
        (inject() as LoginInteractorInterface).generateNewUser {
            (inject() as LoaderInterface).hide()
            self.present(TabBarController(), animated: true)
        }
    }
}
