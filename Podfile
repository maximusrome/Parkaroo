# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'Parkaroo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Parkaroo
  pod 'Firebase/Auth'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
  pod 'Firebase/Performance'
  pod 'Firebase/Messaging'
  pod 'Firebase/Functions'
  pod 'Stripe'

end

post_install do |pi|
    pi.pods_project.targets.each do |t|
        t.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
        end
    end
end
