Pod::Spec.new do |s|
  s.name             = 'QMXMFunModule'
  s.version          = '0.1.0'
  s.summary          = '雄迈SDK组件'
  s.description      = <<-DESC
雄迈SDK组件，方便项目解耦，目前还不支持远程依赖，使用时Download到本地后，在Podfile添加本地依赖：
pod 'QMXMFunModule', :path => 'QMXMFunModule'
                       DESC

  s.homepage         = 'https://github.com/wangdongyang/QMXMFunModule'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wangdongyang' => '877197753@qq.com' }
  s.source           = { :git => 'https://github.com/wangdongyang/QMXMFunModule.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'QMXMFunModule/Classes/**/*.{h,m,mm}'
  
   s.resource_bundles = {
     'QMXMFunModule' => ['QMXMFunModule/Assets/*.png', 'QMXMFunModule/Classes/XMFun/Supporting/Libraries/SVProgressHUD.bundle']
   }
#  1、libz.tbd
#  2、libiconv,
#  3、libbz2,
#  4、libc.tbd
#  5、libresolv,
#  6、AVKit,
#  7、AssetsLibrary,
#  8、UserNotification,
#  9、AudioToolBox,
#  10、CoreMedia,
#  11、OpenAL,
#  12、MediaPlayer,
#  13、AVFoundation,
#  14、OpenGLES,
#  15、GLKit,
#  16、VideoToolbox
#  17、OpenAL.framework,

#1、Build Active Architure Only :YES
#2、Enable Bitode :NO
#3、Enable Testability:NO
#4、Other Linker Flags :-ObjC
#5、C Language Dialect : Compiler Default
#6、C++ Language Dialect :Compiler Default
#7、C++ Standard Library : Compiler Default
#8、Preprocessor Macros : Debug:DEBUG=1 OS_IOS=1 FORMAL=1
#9、Preprocessor Macros :Release :OS_IOS=1 FORMAL=1
#'libresolv','libc.tbd','libbz2','libiconv','libz.tbd'

  s.public_header_files = 'QMXMFunModule/Classes/**/*.h'
  s.prefix_header_file = 'QMXMFunModule/Classes/XMFun/Supporting/MobileVideo-Prefix.pch'
  s.frameworks = ['UIKit','AVFoundation', 'OpenGLES','GLKit','VideoToolbox','OpenAL','MediaPlayer', 'CoreMedia', 'AudioToolBox', 'UserNotifications', 'AssetsLibrary', 'AVKit',]
#  s.library = 'z'
  s.libraries = 'resolv','bz2','iconv','c', 'z'#'c.tbd','z.tbd',
  s.vendored_frameworks = ['QMXMFunModule/Classes/XMFun/Supporting/library/*.framework']
#  s.vendored_libraries = ['QMXMFunModule/Classes/Supporting/Libraries/libstdc++.6.0.9.tbd', 'QMXMFunModule/Classes/Supporting/Libraries/libzbar.a']
  s.user_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
  s.pod_target_xcconfig = {'ENABLE_BITCODE' => 'NO', 'BUILD_ACTIVE_ARCHITURE_ONLY'=>'YES'}
#  s.dependency 'AFNetworking'
#  s.dependency 'Masonry'
#  s.dependency 'TZImagePickerController'
#  s.dependency 'JXPhotoBrowser'
#  s.dependency 'Toast'
#  s.dependency 'LFMediaEditingController'
#  s.dependency 'MJExtension'
end
