
Pod::Spec.new do |s|

  s.name         = "CLSlide_simple"
  s.version      = "1.0.0"
  s.summary      = "网易、凤凰、今日头条等导航栏仿写简单版"
  s.description  = <<-DESC
顶部是多个按钮,可左右滑动、点击,UI效果会跟着变化,下方是多个view
                   DESC

  s.homepage    = "https://github.com/rayonchen/CLSlide_simple"
  s.license     = { :type => "MIT", :file => "LICENSE" }
  s.author      = { "chenglei" => "chenglei@creditzx.com" }
  s.platform    = :ios, "8.0"

  s.source      = { :git => 'https://github.com/rayonchen/CLSlide_simple.git',:tag => s.version }

  s.source_files  = "CLSlidePage_Simple/Slide", "*.{h,m}"
  s.requires_arc = true

end
