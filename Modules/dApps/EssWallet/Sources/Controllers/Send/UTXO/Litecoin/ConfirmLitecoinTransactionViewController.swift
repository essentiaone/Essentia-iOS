//
//  ConfirmLitecoinTransactionViewController.swift
//  EssWallet
//
//  Created by Pavlo Boiko on 3/29/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation

import Foundation
import EssentiaNetworkCore
import EssCore
import EssModel
import EssResources
import HDWalletKit
import EssentiaBridgesApi
import EssUI
import EssDI

class ConfirmLitecoinTxDetailViewController: BaseTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var interactor: WalletBlockchainWrapperInteractorInterface = inject()
    private var litecoinService: LitecoinWalletInterface
    private var utxoSelector: UtxoSelectorInterface
    private var utxoWallet: UTXOWallet
    private var bitcoinConverter: BitcoinConverter
    
    private var viewWallet: ViewWalletInterface
    private var tx: UtxoTxInfo
    private var ammount: UInt64
    private var fee: UInt64?
    private var rawTx: String?
    
    init(_ wallet: ViewWalletInterface, tx: UtxoTxInfo) {
        self.viewWallet = wallet
        self.tx = tx
        litecoinService = LitecoinWallet(EssentiaConstants.bridgeUrl)
        utxoSelector = UtxoSelector(feePerByte: tx.feePerByte, dustThreshhold: 3 * 182)
        let privateKey = PrivateKey(pk: wallet.privateKey, coin: .litecoin)!
        utxoWallet = UTXOWallet(privateKey: privateKey,
                                utxoSelector: utxoSelector,
                                utxoTransactionBuilder: UtxoTransactionBuilder(),
                                utoxTransactionSigner: UtxoTransactionSigner())
        bitcoinConverter = BitcoinConverter(bitcoinString: tx.ammount.inCrypto)
        ammount = bitcoinConverter.inSatoshi
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableAdapter.hardReload(state)
        view.backgroundColor = .clear
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        loadUnspendTransaction()
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
        let ammountFormatter = BalanceFormatter(asset: Coin.litecoin)
        guard let fee = fee else { return "" }
        let feeConverter = BitcoinConverter(satoshi: fee)
        return ammountFormatter.formattedAmmountWithCurrency(amount: feeConverter.inBitcoin)
    }
    
    private func loadUnspendTransaction() {
        litecoinService.getUTxo(for: tx.wallet.address) { (result) in
            switch result {
            case .success(let transactions):
                self.generateTransaction(fromUtxo: transactions)
            case .failure(_):
                self.showInfo(EssentiaError.TxError.failCreateTx.localizedDescription, type: .error)
            }
        }
    }
    
    private func generateTransaction(fromUtxo: [LitecoinUTXO]) {
        let unspendTransactions: [UnspentTransaction] = fromUtxo.map { return $0.unspendTx }
        do {
            let selectedTx = try self.utxoSelector.select(from: unspendTransactions, targetValue: self.ammount)
            self.fee = selectedTx.fee
            let address = try LegacyAddress(tx.address, coin: .litecoin)
            self.rawTx = try utxoWallet.createTransaction(to: address, amount: bitcoinConverter.inSatoshi, utxos: unspendTransactions)
            self.tableAdapter.simpleReload(self.state)
        } catch {
            self.showInfo(EssentiaError.TxError.failCreateTx.localizedDescription, type: .error)
        }
    }
    
    // MARK: - Actions
    private lazy var  cancelAction: () -> Void = { [unowned self] in
        self.dismiss(animated: true)
    }
    
    private lazy var confirmAction: () -> Void = { [unowned self] in
        guard let rawTx = self.rawTx else { return }
        (inject() as LoaderInterface).show()
        self.litecoinService.sendTransaction(with: rawTx) { [unowned self] in
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
