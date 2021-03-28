#
# Be sure to run `pod lib lint XHLRUView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XHLRUView'
  s.version          = '0.0.4'
  s.summary          = 'search history view'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "a tool of search history view"

  s.homepage         = 'https://github.com/Lxh93/XHLRUView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Lxh93' => '894365394@qq.com' }
  s.source           = { :git => 'https://github.com/Lxh93/XHLRUView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'XHLRUView/Classes/**/*'
  
  s.resource_bundles = {
    'XHLRUView' => ['XHLRUView/Assets/*.png']
  }

  s.swift_version = '5.0'
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
