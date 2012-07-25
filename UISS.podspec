Pod::Spec.new do |s|
  s.name     = 'UISS'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.summary  = 'UIKit Style Sheets.'
  s.homepage = 'https://github.com/robertwijas/UISS'
  s.author   = { 'Robert Wijas' => 'robert.wijas@gmail.com' }
  s.source   = { :git => 'git@github.com:robertwijas/UISS.git', :tag => '1.0.0' }
  s.description = 'UISS stands for UIKit Style Sheets. UISS is an iOS library that provides you with a convenient way to define the style of your application. UISS is built on top of UIKit UIAppearance proxies.'
  s.platform = :ios
  s.ios.deployment_target = '5.0'
  s.source_files = 'Project/UISS'
  s.resources = "Project/UISSResources/*.{png,json}"
  s.clean_paths = "Project/UISSDemo", "Project/UISSDemoTests"
  s.frameworks = 'Foundation', 'UIKit'
  s.requires_arc = true
end
