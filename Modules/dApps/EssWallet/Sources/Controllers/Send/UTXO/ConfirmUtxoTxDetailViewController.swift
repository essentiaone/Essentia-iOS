//
//  ConfirmBitcoinTxDetailViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/13/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssentiaNetworkCore
import EssCore
import EssModel
import EssResources
import HDWalletKit
import EssentiaBridgesApi
import EssUI
import EssDI

class ConfirmUtxoTxDetailViewController: BaseTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var interactor: WalletBlockchainWrapperInteractorInterface = inject()

    private var utxoService: UtxoWalletUnterface
    private let utxoCoin: EssModel.Coin
    private var bitcoinConverter: BitcoinConverter
    private var viewWallet: ViewWalletInterface
    private var tx: UtxoTxInfo
    
    init(_ wallet: ViewWalletInterface, tx: UtxoTxInfo, utxoService: UtxoWalletUnterface) {
        self.viewWallet = wallet
        self.tx = tx
        self.utxoService = utxoService
        utxoCoin = wallet.asset as? EssModel.Coin ?? .bitcoin
        bitcoinConverter = BitcoinConverter(bitcoinString: tx.ammount.inCrypto)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
    }
    
    override var state: [TableComponent] {
        return [.blure(state:
            [.centeredComponentTopInstet,
             .container(state: containerState)]
            )]
    }
    
    private var containerState: [TableComponent] {
        return [
            .empty(height: 10, background: .clear),
            .titleWithFontAligment(font: AppFont.bold.withSize(17), title: LS("Wallet.Send.Confirm.Title"), aligment: .center, color: colorProvider.appTitleColor),
            .descriptionWithSize(aligment: .left, fontSize: 14, title: LS("Wallet.Send.Confirm.ToAddress"), background: .clear, textColor: colorProvider.appDefaultTextColor),
            .descriptionWithSize(aligment: .left, fontSize: 13, title: tx.address, background: .clear, textColor: colorProvider.titleColor),
            .empty(height: 5, background: .clear),
            .descriptionWithSize(aligment: .left, fontSize: 14, title: LS("Wallet.Send.Confirm.Amount"), background: .clear, textColor: colorProvider.appDefaultTextColor),
            .descriptionWithSize(aligment: .left, fontSize: 13, title: formattedTransactionAmmount(), background: .clear, textColor: colorProvider.titleColor),
            .empty(height: 5, background: .clear),
            .descriptionWithSize(aligment: .left, fontSize: 14, title: LS("Wallet.Send.Confirm.Fee"), background: .clear, textColor: colorProvider.appDefaultTextColor),
            .descriptionWithSize(aligment: .left, fontSize: 13, title: formattedFee(), background: .clear, textColor: colorProvider.titleColor),
            .empty(height: 10, background: .clear),
            .separator(inset: .zero),
            .twoButtons(lTitle: LS("Wallet.Send.Confirm.Cancel"),
                        rTitle: LS("Wallet.Send.Confirm.Send"),
                        lColor: colorProvider.appDefaultTextColor,
                        rColor: colorProvider.centeredButtonBackgroudColor,
                        lAction: cancelAction,
                        rAction: confirmAction),
            .empty(height: 10, background: .clear)
        ]
    }
    
    private func formattedTransactionAmmount() -> String {
        let cryptoFormatter = BalanceFormatter(asset: viewWallet.asset)
        let inCrypto = cryptoFormatter.formattedAmmountWithCurrency(ammount: tx.ammount.inCrypto)
        let current = EssentiaStore.shared.currentUser.profile?.currency ?? .usd
        let currencyFormatter = BalanceFormatter(currency: current)
        let inCurrency = currencyFormatter.formattedAmmount(ammount: tx.ammount.inCurrency)
        return "\(inCrypto) (\(inCurrency) \(current.symbol))"
    }
    
    private func formattedFee() -> String {
        let ammountFormatter = BalanceFormatter(asset: utxoCoin)
        let feeConverter = BitcoinConverter(satoshi: tx.feeInSatoshi)
        return ammountFormatter.formattedAmmountWithCurrency(amount: feeConverter.inBitcoin)
    }
    
    // MARK: - Actions
    private lazy var  cancelAction: () -> Void = { [unowned self] in
        self.dismiss(animated: true)
    }
    
    private lazy var confirmAction: () -> Void = { [unowned self] in
        (inject() as LoaderInterface).show()
        self.utxoService.sendTransaction(with: self.tx.rawTx) { [unowned self] in
            (inject() as LoaderInterface).hide()
            switch $0 {
            case .success(let object):
                self.dismiss(animated: true)
                (inject() as WalletRouterInterface).show(.doneTx)
            case .failure(let error):
                self.showInfo(error.localizedDescription, type: .error)
            }
        }
    }
}
