Pod::Spec.new do |s|
  s.name         = "NumberScrollAnimatedView"
  s.version      = "0.1.1"
  s.summary      = "UIView based component for displaying string with scroll animation for each numerical symbol"
  s.homepage     = "https://github.com/AlexSmet/NumberScrollAnimatedView"
  # s.screenshots  = "https://user-images.githubusercontent.com/25868364/44025841-e314b52a-9ef9-11e8-98e1-fa3dd7ec95a3.gif"
  s.license      = { :type => 'MIT' }
  s.author             = { "Alexander Smetannikov" => "alexsmetdev@gmail.com" }
  s.platform     = :ios, "9.0"
  s.swift_version = "4.2"
  s.source       = { :git => "https://github.com/AlexSmet/SHNumbersScrollAnimatedView.git", :tag => s.version.to_s}
  s.source_files  = "NumbersScrollAnimatedView/*.{swift}"
  # s.requires_arc = true
end
