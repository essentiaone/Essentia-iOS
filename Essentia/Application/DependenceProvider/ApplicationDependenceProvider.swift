//
//  ApplicationDependenceProvider.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssCore
import EssResources
import EssUI
import EssDI
import EssModel

class ApplicationDependenceProvider {
    func loadDependences() {
        loadAppStateEventProxy()
        loadCoreDependences()
        loadDesignDependences()
        loadServices()
    }
    
    private func loadCoreDependences() {
        prepareInjection(AppImageProvider() as AppImageProviderInterface, memoryPolicy: .viewController)
        prepareInjection(DefaultColorSheme() as AppColorInterface, memoryPolicy: .viewController)
        prepareInjection(CurrencyRankDaemon() as CurrencyRankDaemonInterface, memoryPolicy: .viewController)
    }
    
    private func loadDesignDependences() {
         prepareInjection(BackupDesign() as BackupDesignInterface, memoryPolicy: .viewController)
    }
    
    private func loadAppStateEventProxy() {
        prepareInjection(AppStateEventProxy() as AppStateEventProxyInterface, memoryPolicy: .viewController)
    }
    
    // MARK: - Services
    private func loadServices() {
        prepareInjection(TokenService() as TokensServiceInterface, memoryPolicy: .viewController)
        prepareInjection(LoggerService() as LoggerServiceInterface, memoryPolicy: .viewController)
        prepareInjection(Loader() as LoaderInterface, memoryPolicy: .viewController)
        prepareInjection(MnemonicService() as MnemonicServiceInterface, memoryPolicy: .viewController)
        prepareInjection(DefaultUserStorage() as UserStorageServiceInterface, memoryPolicy: .viewController)
        prepareInjection(ViewUserStorageService() as ViewUserStorageServiceInterface, memoryPolicy: .viewController)
        prepareInjection(LocalFilesService() as LocalFilesServiceInterface, memoryPolicy: .viewController)
        prepareInjection(KeychainService() as KeychainServiceInterface, memoryPolicy: .viewController)
        prepareInjection(CurrencyConverterService() as CurrencyConverterServiceInterface, memoryPolicy: .viewController)
        prepareInjection(WalletBlockchainWrapperInteractor() as WalletBlockchainWrapperInteractorInterface, memoryPolicy: .viewController)
        prepareInjection(LoginInteractor() as LoginInteractorInterface, memoryPolicy: .viewController)
    }
}
