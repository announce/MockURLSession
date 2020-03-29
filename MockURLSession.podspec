#
#  Be sure to run `pod spec lint MockURLSession.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name          = "MockURLSession"
  s.version       = "3.1.0"
  s.summary       = "MockURLSession provides a way to mock NSURLSession."
  s.homepage      = "https://github.com/announce/MockURLSession"
  s.license       = { :type => "MIT" }
  s.author        = { "Kenta Yamamoto" => "http://twitter.com/i05" }
  s.source        = { :git => "https://github.com/announce/MockURLSession.git", :tag => s.version }
  s.source_files  = "#{s.name}/*.swift"
  s.requires_arc  = true
  s.swift_versions = ["5.1"]
  # https://support.apple.com/en-us/HT201260
  s.osx.deployment_target = "10.9"
  # https://support.apple.com/en-us/HT209084
  s.ios.deployment_target = "8.0"
end
