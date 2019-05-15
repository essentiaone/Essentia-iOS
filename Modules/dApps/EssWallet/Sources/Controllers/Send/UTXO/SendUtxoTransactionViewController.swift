//
//  SendUtxoTransactionViewController.swift
//  EssWallet
//
//  Created by Pavlo Boiko on 3/13/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import UIKit
import HDWalletKit
import EssentiaBridgesApi
import QRCodeReader
import EssCore
import EssModel
import EssUI
import EssResources
import EssDI

fileprivate struct Store {
    let wallet: ViewWalletInterface
    let ammount: SelectedTransacrionAmmount
    var address: String = ""
    var selectedFeeSlider: Float = 5
    var isFeeEnteringDirectly: Bool = false
    var lowFee: Double = 1.0
    var fastFee: Double = 30.0
    var keyboardHeight: CGFloat = 0
    var utxo: [UnspentTransaction] = []
    var qrImage: UIImage {
        return (inject() as AppImageProviderInterface).qrCode
    }
    
    var feePerByte: UInt64 {
        return UInt64(selectedFeeSlider)
    }
    
    var isValidTransaction: Bool {
        return wallet.asset.isValidAddress(address)
               && !utxo.isEmpty
               && !address.isEmpty
    }
    
    init(wallet: ViewWalletInterface, transactionAmmount: SelectedTransacrionAmmount) {
        self.wallet = wallet
        self.ammount = transactionAmmount
    }
}

class SendUtxoTransactionViewController: BaseTableAdapterController, QRCodeReaderViewControllerDelegate {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var router: WalletRouterInterface = inject()
    private lazy var interactor: WalletBlockchainWrapperInteractorInterface = inject()

    private var utxoService: UtxoWalletUnterface
    private let utxoCoin: EssModel.Coin
    private var utxoSelector: UtxoSelectorInterface
    private var utxoWallet: UTXOWallet
    private var store: Store
    private var bitcoinConverter: BitcoinConverter
    
    init(wallet: ViewWalletInterface, ammount: SelectedTransacrionAmmount) {
        self.store = Store(wallet: wallet, transactionAmmount: ammount)
        let cryptoWallet = CryptoWallet(
            bridgeApiUrl: EssentiaConstants.bridgeUrl,
            etherScanApiKey: "")
        utxoCoin = wallet.asset as? EssModel.Coin ?? .bitcoin
        let privateKey = PrivateKey(pk: wallet.privateKey, coin: wrapCoin(coin: utxoCoin))!
        utxoSelector = UtxoSelector(feePerByte: self.store.feePerByte, dustThreshhold: 3 * 182)
        utxoWallet = UTXOWallet(privateKey: privateKey,
                                utxoSelector: utxoSelector,
                                utxoTransactionBuilder: UtxoTransactionBuilder(),
                                utoxTransactionSigner: UtxoTransactionSigner())
        utxoService = cryptoWallet.utxoWallet(coin: utxoCoin)
        bitcoinConverter = BitcoinConverter(bitcoinString: ammount.inCrypto)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addLastCellBackgroundContents(topColor: .white, bottomColor: .white)
        keyboardObserver.animateKeyboard = { [unowned self] newValue in
            self.store.keyboardHeight = newValue
            self.tableAdapter.simpleReload(self.state)
        }
        loadUnspendTransaction()
    }

    override var state: [TableComponent] {
        let ammountFormatter = BalanceFormatter(asset: store.wallet.asset)
        return [
            .empty(height: 25, background: colorProvider.settingsCellsBackround),
            .navigationBar(left: LS("Back"),
                           right: "",
                           title: "",
                           lAction: backAction,
                           rAction: nil),
            .attributedTitleDetail(title: NSAttributedString(string: LS("Wallet.Send.Title"),
                                                             attributes: [NSAttributedString.Key.font: AppFont.bold.withSize(28),
                                                                          NSAttributedString.Key.strokeColor: colorProvider.appTitleColor]),
                                   detail: availableBalanceString, action: nil),
            .empty(height: 26, background: colorProvider.settingsCellsBackround),
            .titleCenteredDetail(title: LS("Wallet.Send.Amount"),
                                 detail: ammountFormatter.formattedAmmountWithCurrency(ammount: store.ammount.inCrypto)),
            .separator(inset: .zero),
            .titleCenteredDetailTextFildWithImage(title: LS("Wallet.Send.To"),
                                                  text: store.address,
                                                  placeholder: LS("Wallet.Send.Required"),
                                                  rightButtonImage: store.qrImage,
                                                  rightButtonAction: readQrAction,
                                                  textFieldChanged: addressEditingChanged),
            .separator(inset: .zero)]
             + feeComponents +
            [.calculatbleSpace(background: colorProvider.settingsCellsBackround),
             .empty(height: 8, background: colorProvider.settingsCellsBackround),
             .centeredButton(title: LS("Wallet.Send.GenerateTransaction"),
                             isEnable: store.isValidTransaction,
                             action: continueAction,
                             background: colorProvider.settingsCellsBackround),
             .empty(height: store.keyboardHeight, background: colorProvider.settingsCellsBackround)
        ]
    }

    var feeComponents: [TableComponent] {
        let ammountFormatter = BalanceFormatter(asset: self.store.wallet.asset)
        if store.isFeeEnteringDirectly {
            return [.separator(inset: .zero),
                    .titleCenteredDetailTextFildWithImage(title: LS("Wallet.Send.Fee"),
                                                          text:ammountFormatter.formattedAmmount(amount: Double(self.store.selectedFeeSlider)),
                                                          placeholder: self.store.wallet.asset.symbol,
                                                          rightButtonImage: nil,
                                                          rightButtonAction: nil,
                                                          textFieldChanged: feeChangedDirectly)]
        }
        return [.attributedTitleDetail(title: formattedFeeTitle, detail: formattedInputFeeButton, action: inputFeeAction),
                .slider(titles: (LS("Wallet.Send.Slow"), LS("Wallet.Send.Normal"), LS("Wallet.Send.Fast")),
                        values: (store.lowFee, Double(store.selectedFeeSlider), store.fastFee), didChange: feeChanged)]
    }
    
    // MARK: - Formatters
    var availableBalanceString: NSAttributedString {
        let availableString = NSMutableAttributedString()
        availableString.append(NSAttributedString(string: LS("Wallet.Send.Available") + ": ",
                                                  attributes: titleAttributes))
        availableString.append(NSAttributedString(string: self.store.wallet.formattedBalance,
                                                  attributes: titleAttributes))
        availableString.append(NSAttributedString(string: " "))
        availableString.append(NSAttributedString(string: self.store.wallet.asset.symbol.uppercased(),
                                                  attributes: titleAttributes))
        return availableString
    }
    
    var titleAttributes: [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.font: AppFont.regular.withSize(15),
                NSAttributedString.Key.foregroundColor: colorProvider.titleColor]
    }
    
    var formattedFeeTitle: NSAttributedString {
        let currentFee = Int(self.store.selectedFeeSlider)
        let string = LS("Wallet.Send.Fee") + " \(currentFee) satoshi/byte"
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.font: AppFont.regular.withSize(15),
                                                               NSAttributedString.Key.foregroundColor: colorProvider.titleColor])
    }
    
    var formattedInputFeeButton: NSAttributedString {
        return NSAttributedString(string: LS("Wallet.Send.InputFee"),
                                  attributes: [NSAttributedString.Key.font: AppFont.regular.withSize(12),
                                               NSAttributedString.Key.foregroundColor: colorProvider.centeredButtonBackgroudColor])
    }
    // MARK: - Actions
    private lazy var backAction: () -> Void = { [unowned self] in
        self.view.endEditing(true)
        self.router.pop()
    }
    
    private lazy var continueAction: () -> Void = { [unowned self] in
        do {
            let rawTx = try self.createRawTx()
            let feeInSatoshi = try self.calculateFee()
            self.sendTransaction(rawTx: rawTx, feeInSatoshi: feeInSatoshi)
        } catch {
            self.showInfo(error.localizedDescription, type: .error)
        }
    }
    
    private lazy var inputFeeAction: () -> Void = { [unowned self] in
        self.store.isFeeEnteringDirectly = true
        self.tableAdapter.simpleReload(self.state)
    }
    
    private lazy var readQrAction: () -> Void = { [unowned self] in
        self.keyboardObserver.stop()
        self.tableAdapter.endEditing(true)
        self.router.show(.qrReader(self))
    }
    
    private lazy var addressEditingChanged: (String) -> Void = { [unowned self] address in
        self.store.address = address
        self.tableAdapter.simpleReload(self.state)
    }
    
    private lazy var feeChanged: (Float) -> Void = { [unowned self] fee in
        self.store.selectedFeeSlider = Float(Int(fee))
        self.tableAdapter.hardReload(self.state)
    }
    
    private lazy var feeChangedDirectly: (String) -> Void = { [unowned self] fee in
        self.store.selectedFeeSlider = Float(Int(fee) ?? 5)
        self.tableAdapter.simpleReload(self.state)
    }
    
    // MARK: - Utxo blockchain
    
    private func sendTransaction(rawTx: String, feeInSatoshi: UInt64) {
        let txInfo = UtxoTxInfo(address: self.store.address,
                                ammount: self.store.ammount,
                                wallet: self.store.wallet,
                                feeInSatoshi: feeInSatoshi,
                                rawTx: rawTx)
        let vc = ConfirmUtxoTxDetailViewController(self.store.wallet, tx: txInfo, utxoService: self.utxoService)
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true)
    }
    
    private func loadUnspendTransaction() {
        utxoService.getUtxo(for: self.store.wallet.address) { (result) in
            switch result {
            case .success(let transactions):
                self.store.utxo = transactions.map { return $0.unspendTx }
            case .failure(_):
                self.showInfo(EssentiaError.TxError.failCreateTx.localizedDescription, type: .error)
            }
        }
    }
    
    func calculateFee() throws -> UInt64 {
        let selectedTx = try self.utxoSelector.select(from: self.store.utxo, targetValue: bitcoinConverter.inSatoshi)
        return selectedTx.fee
    }
    
    func createRawTx() throws -> String {
        let address = try LegacyAddress(store.address, coin: wrapCoin(coin: utxoCoin))
        return try utxoWallet.createTransaction(to: address, amount: bitcoinConverter.inSatoshi, utxos: self.store.utxo)
    }
    
    // MARK: - QRCodeReaderViewControllerDelegate (Move to wrapper class)
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        keyboardObserver.start()
        dismiss(animated: true)
        if !result.value.contains(charactersIn: EssCharacters.special.set) {
            self.store.address = result.value
            self.tableAdapter.simpleReload(self.state)
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        keyboardObserver.start()
        dismiss(animated: true)
    }
}
