# Uncomment the next line to define a global platform for your project
 platform :ios, '11.0'
 inhibit_all_warnings!
ENV['COCOAPODS_DISABLE_STATS'] = "true"

workspace 'Essentia.xcworkspace'

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

def pod_functional 
    #pod 'PromiseKit', '~> 6.0'
end

def pod_ui
    pod 'SVProgressHUD' # Can remove later
    pod 'Kingfisher' # Can remove later
    pod 'QRCodeReader.swift' # Can remove later

end

def pod_debug
    pod 'CocoaLumberjack/Swift'
end

target 'EssModel' do
    project 'Modules/EssModel/EssModel.xcodeproj'
    use_frameworks!
    pod_core
end

target 'EssUI' do
    project 'Modules/EssUI/EssUI.xcodeproj'
    use_frameworks!
    pod_ui
    pod_core
end

target 'EssResources' do
    project 'Modules/EssResources/EssResources.xcodeproj'
    use_frameworks!
    pod_core
    pod_debug
end

target 'EssCore' do 
    project 'Modules/EssCore/EssCore.xcodeproj'
    use_frameworks!
    pod_core
    pod_debug
end

target 'Essentia' do
    use_frameworks!
    pod_core
    pod_ui
    pod_debug
    pod_analytics
    pod_functional
end
