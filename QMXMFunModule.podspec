Pod::Spec.new do |s|
  s.name             = 'QMXMFunModule'
  s.version          = '0.1.0'
  s.summary          = 'A short description of QMXMFunModule.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/wangfang/QMXMFunModule'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wangfang' => 'wangfang@sengled.com' }
  s.source           = { :git => 'https://github.com/wangfang/QMXMFunModule.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'QMXMFunModule/Classes/**/*'
  
  # s.resource_bundles = {
  #   'QMXMFunModule' => ['QMXMFunModule/Assets/*.png']
  # }

  s.public_header_files = 'QMXMFunModule/Classes/**/*.h'
  s.prefix_header_file = 'QMXMFunModule/Classes/Supporting/MobileVideo-Prefix.pch'
#  s.frameworks = 'UIKit'
  s.vendored_frameworks = ['QMXMFunModule/Classes/Supporting/library/*.framework']
  s.vendored_libraries = ['QMXMFunModule/Classes/Supporting/Libraries/libstdc++.6.0.9.tbd', 'QMXMFunModule/Classes/Supporting/Libraries/libzbar.a']
#  s.user_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
#  s.pod_target_xcconfig = {'ENABLE_BITCODE' => 'NO'}
  # s.dependency 'AFNetworking', '~> 2.3'
end
