Pod::Spec.new do |s|
    s.name         = 'DLOAuthKit'
    s.version      = '0.1.0'
    s.summary      = 'iOS 第三方登录组件'
    s.homepage     = 'https://github.com/ZengyiMa/DLOAuthKit'
    s.license      = 'MIT'
    s.authors      = {'MaZengyi' => 'semazengyi@gmail.com'}
    s.platform     = :ios, '7.0'
    s.source       = {:git => 'https://github.com/ZengyiMa/DLOAuthKit.git', :tag => s.version}
    s.source_files = 'DLOAuthKit/*.{h,m}'
    s.requires_arc = true
end