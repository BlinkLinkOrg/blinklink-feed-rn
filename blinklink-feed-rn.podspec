require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "blinklink-feed-rn"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = { :type => "Blinklink Source-Available", :file => "LICENSE" }
  s.authors      = { "Blinklink" => "support@blinklink.com" }
  s.source       = { :git => "https://github.com/BlinkLinkOrg/blinklink-feed-rn.git",
                     :tag => "v#{s.version}" }

  s.platforms    = { :ios => "15.0" }
  s.swift_version = "5.10"
  s.source_files = "ios/**/*.{h,m,swift}"

  s.dependency "React-Core"
  s.dependency "BlinklinkFeed", "~> 0.1"
end
