task default: 'lib:build_test'
namespace :lib do

  desc 'Build test'
  task :build_test do
    sh %q(
      xcodebuild test \
        -scheme MockURLSession \
        -sdk iphonesimulator
    )
  end

end
