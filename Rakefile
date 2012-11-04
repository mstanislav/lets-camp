$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'rubygems'
require 'motion-cocoapods'
require 'nano-store'
require 'bubble-wrap'
require 'motion-hpple'

Motion::Project::App.setup do |app|
  app.name = "Let's Camp"
  app.version = "1.1"
  app.deployment_target = '6.0'
  app.identifier = "com.pardalislabs.letscamp"
  #app.codesign_certificate = "iPhone Distribution: Pardalis Labs, LLC"
  app.codesign_certificate = "iPhone Developer: Mark Stanislav (AP9EVYCGVJ)"
  app.provisioning_profile = "/Users/mstanislav/Library/MobileDevice/Provisioning\ Profiles/FB129BD6-D5B4-4CD3-9174-9A19555BE4B6.mobileprovision"
  app.device_family = [:iphone]
  app.interface_orientations = [:portrait]
  #app.icons = %w{Icon-20.png Icon-29.png Icon-57.png Icon-58.png Icon-114.png Icon-512.png Icon-1024.png}
  app.frameworks += ['CoreLocation', 'MapKit', 'CoreData', 'QuartzCore','CoreImage']

  app.pods do
    pod 'NanoStore'
  end
end
