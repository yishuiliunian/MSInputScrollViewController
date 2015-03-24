#
# Be sure to run `pod lib lint MSInputScrollViewController.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MSInputScrollViewController"
  s.version          = "0.1.0"
  s.summary          = "MSInputScrollViewController是一个在内部有输入框的时候自动调整内容大小的视图控制器"
  s.description      = <<-DESC
                       MSInputScrollViewController是一个在内部有输入框的时候自动调整内容大小的视图控制器。这样就不需要每个视图都自己实现监视键盘了。
                        DESC

  s.homepage         = "https://github.com/yishuiliunian/MSInputScrollViewController"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "stonedong" => "yishuiliunian@gmail.com" }
  s.source           = { :git => "https://github.com/yishuiliunian/MSInputScrollViewController.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'MSInputScrollViewController' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'DZGeometryTools'
  s.dependency 'DZProgrameDefines'
end
