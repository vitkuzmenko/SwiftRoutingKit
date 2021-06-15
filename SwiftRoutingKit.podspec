Pod::Spec.new do |s|

  s.name         = "SwiftRoutingKit"
  s.version      = "1.0.0"
  s.summary      = "Routing tools for UIKit swift application"

  s.homepage     = "https://github.com/vitkuzmenko/SwiftRoutingKit.git"

  s.license      = { :type => "Apache 2.0", :file => "LICENSE" }

  s.author             = { "Vitaliy" => "kuzmenko.v.u@gmail.com" }
  s.social_media_url   = "http://twitter.com/vitkuzmenko"

  s.swift_version = '5.4'

  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'

  s.source       = { :git => s.homepage, :tag => s.version.to_s }

  s.source_files  = "Sources/**/*.swift"
  
  s.dependency 'Swinject', '~> 2.7.1'

  end
