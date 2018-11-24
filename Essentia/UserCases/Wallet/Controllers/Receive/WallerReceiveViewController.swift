//
//  WallerReceiveViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/10/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

fileprivate struct Store {
    let wallet: ViewWalletInterface
    var enterdValueInCrypto: String = ""
    
    init(wallet: ViewWalletInterface) {
        self.wallet = wallet
    }
    
    var qrText: String {
        guard !enterdValueInCrypto.isEmpty else {
            return wallet.address
        }
        return wallet.asset.name.lowercased() + ":" + wallet.address + "?" + "value=" + enterdValueInCrypto
    }
}
class WallerReceiveViewController: BaseTableAdapterController, SwipeableNavigation {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var router: WalletRouterInterface = inject()
    private lazy var alert = TopAlert(alertType: .info, title: LS("Wallet.Receive.Copied"), inView: self.view)
    
    private var store: Store
    
    init(wallet: ViewWalletInterface) {
        self.store = Store(wallet: wallet)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableAdapter.hardReload(state)
    }
    
    private var state: [TableComponent] {
        return [
            .empty(height: 25, background: colorProvider.settingsCellsBackround),
            .navigationImageBar(left: LS("Back"),
                                right: UIImage(named: "shareIcon")!,
                                title: "",
                                lAction: backAction,
                                rAction: shareAction),
            .title(bold: true, title:  LS("Wallet.Receive.Title")),
            .empty(height: 30, background: colorProvider.settingsCellsBackround),
            .centeredImage(image: qrImageForText(store.qrText)),
            .calculatbleSpace(background: colorProvider.settingsCellsBackround),
            .titleWithFont(font: AppFont.regular.withSize(17),
                           title: store.wallet.asset.localizedName + " " + LS("Wallet.Receive.Wallet"),
                           background: colorProvider.settingsCellsBackround,
                           aligment: .center),
            .empty(height: 6, background: colorProvider.settingsCellsBackround),
            .titleWithFont(font: AppFont.bold.withSize(13),
                           title: store.wallet.address,
                           background: colorProvider.settingsCellsBackround,
                           aligment: .center),
            .empty(height: 20, background: colorProvider.settingsCellsBackround)]
            + ammountComponent +
            [.separator(inset: .zero),
            .empty(height: 16, background: colorProvider.settingsCellsBackround),
            .smallCenteredButton(title: LS("Wallet.Receive.Copy"), isEnable: true, action: copyAction, background: colorProvider.settingsCellsBackround),
            .empty(height: 24, background: colorProvider.settingsCellsBackround)
        ]
    }
    
    private var ammountComponent: [TableComponent] {
        if store.enterdValueInCrypto.isEmpty {
            return [.menuButton(title: LS("Wallet.Receive.Request"),
                                color: colorProvider.appDefaultTextColor,
                                action: enterAmmoutAction)]
        }
        return [.searchField(title: store.enterdValueInCrypto + " " + store.wallet.asset.symbol,
                                           icon: UIImage(named: "clearTextField") ?? UIImage() ,
                                           action: clearAction)]
    }
    
    private func qrImageForText(_ text: String) -> UIImage {
        let data = text.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return UIImage() }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")
        guard let outputImage = filter.outputImage else { return UIImage() }
        let scale = view.frame.width / 2 / outputImage.extent.width
        let transformedImage = outputImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        
        return UIImage(ciImage: transformedImage)
    }
    
    // MARK: - Actions
    private lazy var backAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        self.router.pop()
    }
    
    private lazy var shareAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        self.present(UIActivityViewController(activityItems: [self.store.wallet.address], applicationActivities: nil), animated: true)
    }
    
    private lazy var copyAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        UIPasteboard.general.string = self.store.wallet.address
        self.alert.show()
    }
    
    private lazy var enterAmmoutAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        self.router.show(.enterReceiveAmmount(self.store.wallet.asset, action: { (ammount) in
            self.store.enterdValueInCrypto = ammount
            self.tableAdapter.simpleReload(self.state)
        }))
    }
    
    private lazy var clearAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        self.store.enterdValueInCrypto = ""
        self.tableAdapter.simpleReload(self.state)
    }
}
