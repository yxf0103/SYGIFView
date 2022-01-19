#
# Be sure to run `pod lib lint SYGIFView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SYGIFView'
  s.version          = '0.1.1'
  s.summary          = 'gif extension for uiimageview'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  'gif extension for uiimageview'
                       DESC

  s.homepage         = 'https://github.com/yxf0103/SYGIFView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yxfeng0103@hotmail.com' => 'ssi-yanxf@dfmc.com.cn' }
  s.source           = { :git => 'https://github.com/yxf0103/SYGIFView', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'SYGIFView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SYGIFView' => ['SYGIFView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
