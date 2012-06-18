# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'rubygems'
require 'motion-cocoapods'
require 'nano-store'
require 'bubble-wrap'
require 'motion-hpple'

Motion::Project::App.setup do |app|
  app.name = "Let's Camp"
  app.interface_orientations = [:portrait]
  app.frameworks += ['CoreLocation', 'MapKit', 'CoreData', 'QuartzCore','CoreImage']

  app.pods do
    dependency 'NanoStore'
  end
end
