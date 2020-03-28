task default: %w[test]

task test: [
  :set_options,
  :test_ios,
  :pod_lint,
]

task :set_options do
  sh %q(set -o pipefail)
end

task :test_ios do
  sh %q(
    xcodebuild test \
      -scheme MockURLSession \
      -destination 'platform=iOS Simulator,name=iPhone 8'
  )
end

task :pod_lint do
  sh %q(
    pod lib lint
  )
end
