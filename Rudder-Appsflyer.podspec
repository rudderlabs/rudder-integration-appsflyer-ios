require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

appsflyer_sdk_version = '~> 6.12'
rudder_sdk_version = '~> 1.12'

Pod::Spec.new do |s|
  s.name             = 'Rudder-Appsflyer'
  s.version          = package['version']
  s.summary          = 'Privacy and Security focused Segment-alternative. Appsflyer Native SDK integration support.'

  s.description      = <<-DESC
Rudder is a platform for collecting, storing and routing customer event data to dozens of tools. Rudder is open-source, can run in your cloud environment (AWS, GCP, Azure or even your data-centre) and provides a powerful transformation framework to process your event data on the fly.
                       DESC

  s.homepage         = 'https://github.com/rudderlabs/rudder-integration-appsflyer-ios'
  s.license          = { :type => "Apache", :file => "LICENSE.md" }
  s.author           = { 'RudderStack' => 'sdk@rudderstack.com' }
  s.source           = { :git => 'https://github.com/rudderlabs/rudder-integration-appsflyer-ios.git', :tag => "v#{s.version}" }
  s.platform         = :ios, "9.0"

  s.ios.deployment_target = '10.0'

  s.static_framework = true

  s.source_files = 'Rudder-Appsflyer/Classes/**/*'

  if defined?($AppsflyerSDKVersion)
    Pod::UI.puts "#{s.name}: Using user specified Appsflyer SDK version '#{$AppsflyerSDKVersion}'"
    appsflyer_sdk_version = $AppsflyerSDKVersion
  else
    Pod::UI.puts "#{s.name}: Using default Appsflyer SDK version '#{appsflyer_sdk_version}'"
  end

  if defined?($RudderSDKVersion)
    Pod::UI.puts "#{s.name}: Using user specified Rudder SDK version '#{$RudderSDKVersion}'"
    rudder_sdk_version = $RudderSDKVersion
  else
    Pod::UI.puts "#{s.name}: Using default Rudder SDK version '#{rudder_sdk_version}'"
  end


  s.dependency 'Rudder', rudder_sdk_version
  s.dependency 'AppsFlyerFramework', appsflyer_sdk_version
end
