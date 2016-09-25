Pod::Spec.new do |s|

  s.name         = "Notificationz"
  s.version      = "2.0.0"
  s.summary      = "Helping you own NSNotificationCenter!"
  s.description  = <<-DESC
                   Provides a customizable wrapper around NSNotificationCenter
                   with Swifter APIs.
                   DESC

  s.homepage     = "http://kitz.io"
  s.license      = "MIT"
  s.author             = { "Maz Jaleel" => "mazjaleel@gmail.com" }
  s.social_media_url   = "http://twitter.com/SwiftKitz"

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/SwiftKitz/Notificationz.git", :tag => "v2.0.0" }
  s.source_files = "Notificationz/Notificationz/**/*.swift"
end
