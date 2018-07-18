# More documentation about how to customize your build
# can be found here:
# https://docs.fastlane.tools
fastlane_version "2.68.0"

generated_fastfile_id "e378d6a8-cb3a-44d8-bf7f-8fa5c5cc0d32"

default_platform :ios

# Fastfile actions accept additional configuration, but
# don't worry, fastlane will prompt you for required
# info which you can add here later
platform :ios do

  before_all do
    ENV["SLACK_URL"] = "https://hooks.slack.com/services/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"
  end

  desc "installing current pod dependecies"
  lane :pod_install do
    cocoapods(
      clean: true,
      repo_update: true,
      use_bundle_exec: false
    )
  end

  desc "Kill all simulators"
  lane :kill_simulators do |options|
    puts("Shutting down the simulator app")
    sh("osascript -e 'quit app \"Simulator\"'")
  end

  desc "Build the project without export"
  lane :build do
    pod_install
    increment_build_number
    xcbuild(
    workspace: "Essentia.xcworkspace",
    scheme: "Essentia",
    configuration: "Debug",
    clean: true,
    build: true,
    destination: "generic/platform=iOS",
    build_settings: {
      "CODE_SIGNING_REQUIRED" => "NO",
      "CODE_SIGN_IDENTITY" => ""
      }
    )
  end

  # upload to Testflight
  pilot(skip_waiting_for_build_processing: true)

  increment_build_number(
    build_number: latest_testflight_build_number + 1,
    xcodeproj: "Essentia.xcodeproj"
  )

  error do |lane, exception|
    if lane == :adhoc_for_qa
      slack(
        channel: "#ios-dream-team",
        message: exception.message,
        success: false
      )
    end
  end
end
