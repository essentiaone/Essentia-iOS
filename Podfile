# Uncomment the next line to define a global platform for your project
 platform :ios, '11.0'

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/essentiaone/ess-cocoapodspec.git'

def pod_analytics
    pod 'Fabric'
    pod 'Crashlytics'
end

def pod_core
   pod 'HDWalletKit'
   pod 'essentia-bridges-api-ios'
   pod 'essentia-network-core-ios'
end

def pod_ui
    pod 'SVProgressHUD'
    pod 'Kingfisher'
end

def pod_debug
    pod 'CocoaLumberjack/Swift'
end

target 'Essentia' do
    use_frameworks!
    pod_core
    pod_ui
    pod_debug
    pod_analytics
    
end
