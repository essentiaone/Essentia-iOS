# Uncomment the next line to define a global platform for your project
 platform :ios, '10.0'

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/essentiaone/ess-cocoapodspec.git'

def pod_analytics
    pod 'Fabric'
    pod 'Crashlytics'
end

def pod_core
   pod 'HDWalletKit'
   pod 'essentia-bridges-api-ios'
end

target 'Essentia' do
    use_frameworks!
    pod_core
    pod_analytics
    
end
