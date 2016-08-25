task default: %w[test]

task test: [:test_osx, :test_ios, :test_tvos]

task :test_osx do
  sh %q(
    xcodebuild test \
      -scheme MockURLSession
  )
end

task :test_ios do
  sh %q(
    xcodebuild test \
      -scheme MockURLSession \
      -destination 'platform=iOS Simulator,name=iPhone 6'
  )
end

task :test_tvos do
  sh %q(
    xcodebuild test \
      -scheme MockURLSession \
      -destination 'platform=tvOS Simulator,name=Apple TV 1080p'
  )
end
