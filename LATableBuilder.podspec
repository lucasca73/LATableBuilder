#
# Be sure to run `pod lib lint LATableBuilder.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LATableBuilder'
  s.version          = '0.2.1'
  s.summary          = 'LATableBuilder makes implementing table views a piece of cake'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  LATableBuilder
  
  Never worry anymore about datasource, delegate or registering cells. Handle the cell setup when declaring the cell.
  This will speed up the productivity and let the code clearer without the same standard setup everytime.
  
  This pod aims to make easier the use of UITableView.
  
  MIT license, use as you wish.
                       DESC

  s.homepage         = 'https://github.com/lucasca73/LATableBuilder'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Lucas Costa Araujo' => 'lucascostaa73@gmail.com' }
  s.source           = { :git => 'https://github.com/lucasca73/LATableBuilder.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'

  s.source_files = 'LATableBuilder/Classes/**/*'
  
  s.dependency 'SnapKit', '~> 5.0.1'
  
  # s.resource_bundles = {
  #   'LATableBuilder' => ['LATableBuilder/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
end
