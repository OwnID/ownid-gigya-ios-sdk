Pod::Spec.new do |s|
  s.name             = 'ownid-gigya-ios-sdk'
  s.version          = '0.0.9'
  s.summary          = 'ownid-gigya-ios-sdk'

  s.description      = <<-DESC
  ownid-gigya-ios-sdk
                       DESC

  s.homepage         = 'https://ownid.com'
  s.license          = 'Apache 2.0'
  s.author           = { 'Yurii Boiko' => 'counter-sawdust0z@icloud.com' }

  #, :tag => s.version.to_s
  s.source           = { :git => 'https://github.com/OwnID/ownid-gigya-ios-sdk.git' }
  s.module_name   = 'OwnIDGigyaSDK'
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.1.1'

  s.source_files = 'Core/**/*'
  s.dependency 'ownid-core-ios-sdk'
  s.dependency 'Gigya'
end