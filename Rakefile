task default: %w[test]

task test: [
  :set_options,
  :test_ios,
]

task :set_options do
  sh %q(set -o pipefail)
end

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
