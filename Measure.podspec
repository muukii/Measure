Pod::Spec.new do |s|
  s.name             = 'Measure'
  s.version          = '0.7.0'
  s.summary          = 'Performance measurement tool'
  s.homepage         = 'https://github.com/muukii/Measure'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'muukii' => 'muukii.app@gmail.com' }
  s.source           = { :git => 'https://github.com/muukii/Measure.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/muukii0803'
  s.ios.deployment_target = '8.0'
  s.source_files = 'Measure/**/*.swift'
end
