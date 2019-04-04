//
//  WalletOptionsViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/10/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssModel
import EssResources
import EssUI
import EssDI

fileprivate enum SelectedOption {
    case none
    case rename
    case export
}

class WalletOptionsViewController: BaseBluredTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var router: WalletRouterInterface = inject()
    
    private var wallet: ViewWalletInterface
    private var selected: SelectedOption
    private var enteredName: String
    private var keyboardHeight: CGFloat = 216
    
    init(wallet: ViewWalletInterface) {
        self.wallet = wallet
        self.selected = .none
        self.enteredName = wallet.name
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var state: [TableComponent] {
        return [
            .calculatbleSpace(background: .clear),
            .container(state: containerState),
            .empty(height: 18, background: .clear)
            ] + keyboardIfNeedState
    }
    
    private var keyboardIfNeedState: [TableComponent] {
        guard selected == .rename else { return [] }
        return [.empty(height: keyboardHeight, background:.clear)]
    }
    
    private var containerState: [TableComponent] {
        return
            [.titleWithCancel(title: LS("Wallet.Options.Title"), action: backAction),
             .imageTitle(image: imageProvider.walletOptionsRename, title: LS("Wallet.Options.Rename"), withArrow: false, action: renameAction)]
                + editTextField +
                [.imageTitle(image: imageProvider.walletOptionsExport, title: LS("Wallet.Options.Export"), withArrow: false, action: exportAction)]
                + exportPrivateKey +
                [.imageTitle(image: imageProvider.walletOptionsDelete, title: LS("Wallet.Options.Delete"), withArrow: false, action: deleteAction)]
    }
    
    private var editTextField: [TableComponent] {
        guard selected == .rename else { return [] }
        return [.textField(placeholder: wallet.asset.localizedName,
                           text: enteredName,
                           endEditing: nameAction,
                           isFirstResponder: true),
                .empty(height: 12, background: .white)
        ]
    }
    
    private var exportPrivateKey: [TableComponent] {
        guard selected == .export else { return [] }
        return [.titleWithFontAligment(font: AppFont.bold.withSize(14), title: LS("Wallet.Options.Export.PK"), aligment: .left, color: colorProvider.appTitleColor),
                .titleAction(font: AppFont.regular.withSize(15), title: privateKey, action: copyAction)]
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableAdapter.hardReload(state)
        keyboardObserver.animateKeyboard = { [unowned self] newValue in
            if newValue != 0 {
                self.keyboardHeight = newValue
                self.tableAdapter.simpleReload(self.state)
            }
        }
    }
    
    // MARK: - Actions
    private lazy var backAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        self.tableAdapter.endEditing(true)
        (inject() as UserStorageServiceInterface).update({ _ in
            self.wallet.name = self.enteredName
        })
        self.dismiss(animated: true)
    }
    
    private lazy var renameAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        self.selected = .rename
        self.tableAdapter.simpleReload(self.state)
    }
    
    private lazy var exportAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        self.selected = .export
        self.tableAdapter.hardReload(self.state)
    }
    
    private lazy var deleteAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        self.selected = .none
        self.tableAdapter.endEditing(true)
        self.showDeleteWarning()
        self.tableAdapter.simpleReload(self.state)
    }
    
    private lazy var nameAction: (String) -> Void = { [weak self] name in
        guard let `self` = self else { return }
        self.enteredName = name
    }
    
    private lazy var copyAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        self.selected = .export
        (inject() as LoaderInterface).showInfo(LS("Wallet.Options.Export.Copied"))
        UIPasteboard.general.string = self.privateKey
        self.tableAdapter.simpleReload(self.state)
    }
    
    private func showDeleteWarning() {
        self.present(DeleteWalletWarningViewController(wallet: wallet, leftAction: {}, rightAction: { [weak self] in
            guard let `self` = self else { return }
            let walletName = self.wallet.name
            (inject() as UserStorageServiceInterface).update({ (user) in
                user.wallet?.remove(wallet: self.wallet)
            })
            self.dismiss(animated: true, completion: {
                (inject() as WalletRouterInterface).show(.walletDeleted(walletName: walletName))
            })
        }), animated: true)
    }
    
    var privateKey: String {
        return wallet.privateKey
    }
}
