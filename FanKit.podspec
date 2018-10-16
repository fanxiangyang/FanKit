#
#  Be sure to run `pod spec lint FanKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "FanKit"
  s.version      = "0.1.0"
  s.summary      = "A Cocoa Tool Kit of iOS components."
  s.description  = <<-DESC
            一个iOS集成实用工具库,以后会添加更多更多的工具，实用类，封装类，封装小效果
                   DESC

  s.homepage     = "https://github.com/fanxiangyang/FanKit"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "fanxiangyang" => "fqsyfan@gmail.com" }
  # s.social_media_url   = "http://twitter.com/fanxiangyang"

  s.platform     = :ios, "8.0"

  s.ios.deployment_target = "8.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/fanxiangyang/FanKit.git", :tag => s.version.to_s }

  s.source_files  = "Classes/FanKit.h","Classes/FanKitHead.h"
  #s.exclude_files = "Classes/Exclude"

  s.public_header_files = "Classes/FanKit.h","Classes/FanKitHead.h"

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"
  s.resources = "Classes/Core/FanKit.bundle"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  #s.frameworks = "UIKit", "QuartzCore"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

  s.subspec 'Core' do |ss|
    ss.source_files  = "Classes/Core/*.{h,m}"
    ss.public_header_files = "Classes/Core/*.h"
    ss.frameworks = "UIKit", "QuartzCore"
  end

  s.subspec 'UIKit' do |ss|
    ss.public_header_files = 'Classes/UIKit/*.h'
    ss.source_files = 'Classes/UIKit/*.{h,m}'
    ss.frameworks = "UIKit"
  end

  s.subspec 'Libs' do |ss|
    ss.public_header_files = 'Classes/Libs/**/*.h'
    ss.source_files = 'Classes/Libs/**/*.{h,m}'
    ss.frameworks = "UIKit"
  end

end




