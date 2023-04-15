# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'EasyAudio' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for EasyAudio

pod 'Alamofire', '~> 5.2.2'
pod 'AlamofireImage', '~> 4.1.0'
pod 'SnapKit'
pod 'RealmSwift', '~> 4.3.2'
pod 'RxSwift'
pod 'RxCocoa'
pod 'Kingfisher', '~> 5.12.0'
pod 'SwiftyJSON'
pod 'Eureka'
pod 'Cosmos'
pod 'SVProgressHUD'
pod "ViewAnimator"
pod 'PhotoSlider'
pod 'FDWaveformView'
pod 'UIDropDown'
pod 'WMSegmentControl'
pod 'HGCircularSlider'
pod 'SwiftGen'
pod 'HKVideoRangeSlider'
pod 'Firebase'
pod 'SwiftyStoreKit'
pod 'KeychainSwift'
pod 'Firebase'
pod 'Firebase/Firestore'
pod 'FirebaseFirestoreSwift'
pod 'FirebaseAuth'
pod 'Firebase/RemoteConfig'
pod 'DKImagePickerController'
pod 'EasyBaseCodes'
pod 'EasyBaseAudio'
pod 'SwiftLint'

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end

end
