platform :ios, ‘9.0’
use_frameworks!
inhibit_all_warnings!

target ‘Stylendar’ do
	pod "Firebase”
	pod "Firebase/Auth"
	pod “FirebaseCommunity”
	pod “FirebaseInstanceID”
	pod "Firebase/Database"
	pod "Firebase/DynamicLinks”
	pod "Firebase/Messaging”
	pod "Firebase/Storage”
    	pod "Alamofire", "~> 4.3"
	pod “BadgeSwift”
	pod “Crashlytics”
	pod “CSStickyHeaderFlowLayout”,
    	 	:git => ‘https://github.com/CSStickyHeaderFlowLayout/CSStickyHeaderFlowLayout.git',
    	 	:branch => ‘swift’
	pod "CWStatusBarNotification"
	pod “Device”
	pod "DZNEmptyDataSet"
	pod “Fabric”
	pod “iCarousel”
	pod "IQKeyboardManager"
	pod "LKAlertController"
	pod "PromiseKit", "4.5.0"
	pod 'PromiseKit/Alamofire', "4.5.0"
	pod “ReachabilitySwift”, “~> 3”
	pod "SAMKeychain"
	pod "SDWebImage"
	pod “SVProgressHUD”
	pod "SwiftyUserDefaults"
	pod "SwiftyJSON"
	pod "SwiftDate"
	pod “ZSWSuffixTextView”

	target ‘StylendarTests’ do
        	inherit! :search_paths
        	pod 'Firebase'
		pod ‘SwiftDate’
    	end
end		
post_install do |installer|
  installer.pods_project.targets.each do |target|
    if ['SwiftyJSON'].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.0'
      end
    end
  end
end
