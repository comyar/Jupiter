Pod::Spec.new do |s|
 s.name = 'Jupiter'
 s.version = '0.0.1'
 s.license = { :type => "MIT", :file => "LICENSE" }
 s.summary = 'The Swift Weather Framework'
 s.homepage = 'http://comyar.io'
 s.authors = { "Comyar Zaheri" => "comyarzaheri@gmail.com" }
 s.source = { :git => "https://github.com/comyar/Jupiter.git", :tag => s.version.to_s }
 s.platforms = { :ios => "10.0", :osx => "10.12", :tvos => "10.0", :watchos => "2.0" }
 s.requires_arc = true
 s.dependency 'Unbox', '~> 2.3'

 s.default_subspec = "Core"
 s.subspec "Core" do |ss|
     ss.source_files  = "Sources/*.swift"
     ss.framework  = "Foundation"
 end

end
