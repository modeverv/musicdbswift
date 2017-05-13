# Uncomment this line to define a global platform for your project
# frozen_string_literal: true

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'musicdb' do
  pod 'SwiftyJSON'
  pod 'MarqueeLabel'
  pod 'SVProgressHUD'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |configuration|
      configuration.build_settings['SWIFT_VERSION'] = '3.1'
    end
  end
end
