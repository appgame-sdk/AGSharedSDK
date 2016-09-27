
Pod::Spec.new do |s|
  s.name         = "AGSharedSDK"
  s.version      = " 0.1.0"
  s.summary      = "this is demo of SDK dfasdf dfasff"
  s.description  = <<-DESC
               this is a demo of  SDK aa aa.fsaf法法师法
               DESC
  s.homepage     = "https://github.com/appgame-sdk"
  s.license      = "MIT"
 s.author             = { "luoweixian" => "luoweixian@appgame.com" }
  s.platform     = :ios
  s.ios.deployment_target = "5.0"
   s.source       = { :git => "https://github.com/appgame-sdk/AGSharedSDK.git", :tag => s.version }
   s.source_files = 'classes/PlatformType/*.{h,m}'
   s.resources =  'classes/PlatformType.bundle'
  s.requires_arc = true
    s.frameworks = 'UIKit', 'ImageIO', 'CoreTelephony', 'CoreGraphics', 'Security'
    
    # s.vendored_frameworks = 'classes/Vendor/QQSDK/TencentOpenAPI.framework'
    # s.vendored_frameworks = 'classes/PlatformType/AGShareSDK.framework'
    # s.resources = 'classes/Vendor/SinaWeiboSDK/WeiboSDK.bundle','classes/Vendor/QQSDK/TencentOpenApi_IOS_Bundle.bundle'
  # s.libraries =  'libc++abi.tbd', 'libz', 'libsqlite3','libc++'
  # s.dependency "AFNetworking"
 #  s.dependency "NYXImagesKit"
 #
 #
 #  s.subspec 'BlocksKit' do |ss|
 #   # ss.source_files = 'classes/Vendor/BlocksKit'
 #  end
 #
 #   s.subspec 'UI' do |ss|
 #    # ss.source_files = 'classes/UI/**/*'
 #   end
 #
 #   s.subspec 'QQSDK' do |ss|
 #     ss.vendored_frameworks = 'classes/Vendor/QQSDK/TencentOpenAPI.framework'
 #     ss.resources = 'classes/Vendor/QQSDK/TencentOpenApi_IOS_Bundle.bundle'
 #   end
 #   s.subspec 'SinaWeiboSDK' do |ss|
 #     # ss.source_files = 'classes/Vendor/SinaWeiboSDK/**/*'
 #     ss.vendored_libraries = "classes/Vendor/SinaWeiboSDK/libWeiboSDK.a"
 #     ss.resources = "classes/Vendor/SinaWeiboSDK/WeiboSDK.bundle"
 #   end
 #   s.subspec 'WeChat' do |ss|
 #     # ss.source_files = 'classes/Vendor/WeChatSDK/**/*'
 #     ss.vendored_libraries = "classes/Vendor/SinaWeiboSDK/libWeChatSDK.a"
 #   end
end

