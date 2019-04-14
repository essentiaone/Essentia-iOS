platform :ios, '11.0'
inhibit_all_warnings!
ENV['COCOAPODS_DISABLE_STATS'] = "true"

workspace 'Essentia.xcworkspace'

source 'https://github.com/CocoaPods/Specs.git'

# Pods def

def pod_analytics
    pod 'Fabric'
    pod 'Crashlytics'
end

def pod_core
   pod 'HDWalletKit'
   pod 'essentia-bridges-api-ios'
   pod 'essentia-network-core-ios'
end

def pod_notification
    pod 'Firebase/Core'
    pod 'Firebase/Messaging'
end


def pod_functional 
    #pod 'PromiseKit', '~> 6.0'
end

def pod_ui
    pod 'SVProgressHUD' # Can remove later
    pod 'Kingfisher', '5.1.1' # Can remove later
    pod 'QRCodeReader.swift' # Can remove later
    pod 'AvatarHashView'
end

def pod_debug
    pod 'CocoaLumberjack/Swift'
end

def pod_database
    pod 'RealmSwift'
end

# Core functionality

target 'EssModel' do
    project 'Modules/EssModel/EssModel.xcodeproj'
    use_frameworks!
    pod_database
end

target 'EssUI' do
    project 'Modules/EssUI/EssUI.xcodeproj'
    use_frameworks!
    pod_ui
end

target 'EssResources' do
    project 'Modules/EssResources/EssResources.xcodeproj'
    use_frameworks!
    pod_debug
    pod_database
end

target 'EssDI' do
    project 'Modules/EssDI/EssDI.xcodeproj'
    use_frameworks!
    
end

target 'EssCore' do 
    project 'Modules/EssCore/EssCore.xcodeproj'
    use_frameworks!
    pod_debug
    pod_ui
    pod_core
end

# dApps

target 'EssWallet' do 
    project 'Modules/dApps/EssWallet/EssWallet.xcodeproj'
    use_frameworks!
    pod_core
    pod_debug
    pod_ui
    pod_database
end

# =====

target 'Essentia' do
    use_frameworks!
    pod_core
    pod_ui
    pod_debug
    pod_analytics
    pod_functional
    pod_database
    pod_notification
end

target 'EssUIGallery' do 
    project 'Modules/EssUIGallery/EssUIGallery.xcodeproj'
    use_frameworks!
    pod_core
    pod_ui
    pod_database
    pod_debug
end
