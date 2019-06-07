//
//  SelectPurchaseViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 5/21/19.
//  Copyright © 2019 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssResources
import EssUI
import EssDI
import EssModel

public class SelectPurchaseViewController: BaseTableAdapterController, SwipeableNavigation {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var purchaseNetworking: PurchcaseNetworkingServiceInterface = PurchaseNetworkingService()
    private lazy var blockchainService: WalletBlockchainWrapperInteractorInterface = inject()
    private lazy var interactor: WalletBlockchainWrapperInteractorInterface = inject()
    private lazy var purchaseService: PurchaseServiceInterface = PurchaseService()
    
    private var purchaseAddresss: String?
    private var gasSpeed: Double?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        loadPurchaseAddress()
        loadGasPrice()
    }
    
    override public var state: [TableComponent] {
        return [
            .empty(height: 25, background: colorProvider.settingsCellsBackround),
            .navigationBar(left: LS("Back"),
                           right: LS("PaidAccount.SelectPurchase.Restore"),
                           title: "",
                           lAction: backAction,
                           rAction: restoreAction),
            .empty(height: 10, background: .clear),
            .title(bold: true, title: LS("PaidAccount.SelectPurchase.Title")),
            .calculatbleSpace(background: .clear),
            .centeredImage(image: imageProvider.selectPurchaseTypeIcon),
            .empty(height: 19, background: .clear),
            .descriptionWithSize(aligment: .left,
                                 fontSize: 17,
                                 title: LS("PaidAccount.SelectPurchase.Info"),
                                 background: .clear,
                                 textColor: colorProvider.appLinkTextColor),
            .empty(height: 25, background: .clear),
            .buttonWithSubtitle(title: LS("PaidAccount.SelectPurchase.PayForOne"), subtitle: "FOR 5 ESS", color: colorProvider.centeredButtonBackgroudColor, action: buyOneAccount),
            .empty(height: 10, background: .clear),
            .buttonWithSubtitle(title: LS("PaidAccount.SelectPurchase.PayForUnlimited"), subtitle: "FOR 100 ESS", color: colorProvider.copyButtonBackgroundSelectedColor, action: buyUnlimitedAccounts),
            .empty(height: 16, background: .clear)
        ]
    }
    
    private lazy var buyOneAccount: () -> Void = { [unowned self] in
        self.present(SelectAccountToPurchaseViewController({ user in
            self.logInToUser(user: user, userResult: { loggedUser in
                self.selectPurchaseWallet(user: loggedUser, selectedWallet: { (purhcaseWallet) in
                    self.createPurchaseTransaction(wallet: purhcaseWallet, payType: .single)
                    self.dismiss(animated: true)
                })
            })
        }), animated: true)
    }
    
    private lazy var buyUnlimitedAccounts: () -> Void = { [unowned self] in
        self.present(SelectAccountToPurchaseViewController({ user in
            self.logInToUser(user: user, userResult: { loggedUser in
                self.selectPurchaseWallet(user: loggedUser, selectedWallet: { (purhcaseWallet) in
                    self.createPurchaseTransaction(wallet: purhcaseWallet, payType: .unlimited)
                    self.dismiss(animated: true)
                })
            })
        }), animated: true)
    }
    
    private func logInToUser(user: ViewUser, userResult: @escaping (User) -> Void) {
        self.present(LoginPasswordViewController(userId: user.id, hash: user.passwordHash, password: { (password) in
            self.dismiss(animated: true)
            guard let loggedUser = try? RealmUserStorage(seedHash: user.id, password: password) else { return }
            userResult(loggedUser.getOnly)
        }, cancel: {
            self.dismiss(animated: true)
        }), animated: true)
    }
    
    private func selectPurchaseWallet(user: User, selectedWallet: @escaping (ViewWalletInterface) -> Void) {
        let wallets: [ViewWalletInterface] = user.wallet?.tokenWallets.map { $0 } ?? []
        let essentiaWallets = wallets.filter { return $0.asset == Token.essentiaAsset }
        guard !essentiaWallets.isEmpty else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                self.showInfo("You do not have Ess wallet on this account!", type: .error)
            })
            return
        }
        let currency = user.profile?.currency ?? .usd
        self.present(SelectPurchaseWalletViewController(wallets: essentiaWallets,
                                                        currency: currency,
                                                        didSelect: selectedWallet), animated: true)
    }
    
    private func loadPurchaseAddress() {
        purchaseNetworking.purchaseAddress { (result) in
            switch result {
            case .success(let address):
                self.purchaseAddresss = address.address
            case .failure(let error):
                (inject() as LoggerServiceInterface).log(error.localizedDescription)
                (inject() as LoaderInterface).showError("Try again later!")
            }
        }
    }
    
    private func createPurchaseTransaction(wallet: ViewWalletInterface, payType: PurchasePrice) {
        let txAmmount = SelectedTransacrionAmmount(inCrypto: String(payType.rawValue), inCurrency: "")
        guard let address = purchaseAddresss,
            let gasSpeed = gasSpeed else {
                (inject() as LoaderInterface).showError("Can not make purchase, try later!")
                return
        }
        
        guard let rawParametrs = try? interactor.txRawParametrs(for: wallet.asset, toAddress: address, ammountInCrypto: txAmmount.inCrypto, data: Data(hex: "0x")) else {
            return
        }
        (inject() as LoaderInterface).show()
        interactor.getTokenBalance(for: Token.essentia, address: wallet.address) { (tokenBalance) in
            self.interactor.getEthGasEstimate(fromAddress: wallet.address, toAddress: rawParametrs.address, data: rawParametrs.data.toHexString().addHexPrefix()) { [unowned self] (result) in
                switch result {
                case .success(let price):
                    let txInfo = EtherTxInfo(address: address,
                                             ammount: txAmmount,
                                             data: "",
                                             fee: 0,
                                             gasPrice: Int(gasSpeed * pow(10.0, 9)),
                                             gasLimit: Int(price.value))
                    let fee = Double(gasSpeed) * price.value / pow(10, 9)
                    self.blockchainService.getCoinBalance(for: .ethereum, address: wallet.address, balance: { (balance) in
                        (inject() as LoaderInterface).hide()
                        if balance >= fee && tokenBalance >= payType.rawValue {
                            self.present(ConfirmPurchaseViewController(wallet, tx: txInfo, completeCallback: self.showDoneTransaction), animated: true)
                        } else {
                            (inject() as LoaderInterface).showError("Do not have enough Ethereum!")
                        }
                    })
                case .failure(let error):
                    (inject() as LoaderInterface).hide()
                    self.showInfo(error.localizedDescription, type: .error)
                }
            }
        }
    }
    
    private func loadGasPrice() {
        blockchainService.getGasSpeed { (_, medium, _) in
            self.gasSpeed = medium
        }
    }
    
    private func showDoneTransaction() {
        self.present(DonePurchaseViewController(doneAction: { [unowned self] in
            self.dismiss(animated: true, completion: {
                (inject() as LoaderInterface).showInfo("Now you create new account!")
            })
            
        }), animated: true)
    }
    
    private lazy var restoreAction: () -> Void = { [unowned self] in
        self.present(SelectAccountToPurchaseViewController({ user in
            self.logInToUser(user: user, userResult: { loggedUser in
                self.selectPurchaseWallet(user: loggedUser, selectedWallet: { (purhcaseWallet) in
                    self.purchaseService.getPurchaseType(for: purhcaseWallet.address, result: { (type) in
                        switch type {
                        case .unlimited, .singeAccount:
                            UserDefaults.standard.setValue(purhcaseWallet.address, forKey: EssDefault.purchaseAddress.rawValue)
                            self.dismiss(animated: true, completion: {
                                self.dismiss(animated: true)
                                    (inject() as LoaderInterface).showInfo("Purchases succesfully restored!")
                            })
                        case .notPurchased:
                            self.showInfo("Wrong wallet.", type: .error)
                        }
                    })
                    self.dismiss(animated: true)
                })
            })
        }), animated: true)
    }
    
    private lazy var backAction: () -> Void = { [unowned self] in
        self.dismiss(animated: true)
    }
}
