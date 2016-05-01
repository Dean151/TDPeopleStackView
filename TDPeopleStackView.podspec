#
# Be sure to run `pod lib lint TDPeopleStackView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "TDPeopleStackView"
  s.version          = "0.1.0"
  s.summary          = "A stacked view to present a list of persons with their picture or initials"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A stacked view to present a list of persons with their picture or initials
You can also add a button with a custom action.
Maybe in the future there will have be some more features to come
                       DESC

  s.homepage         = "https://github.com/Dean151/TDPeopleStackView"
  s.screenshots     = "https://raw.githubusercontent.com/Dean151/TDPeopleStackView/master/Screenshots/presentation.png",
  s.license          = 'MIT'
  s.author           = { "Dean151" => "thomas.durand.verjat@gmail.com" }
  s.source           = { :git => "https://github.com/Dean151/TDPeopleStackView.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/cafelembas'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TDPeopleStackView/Classes/**/*'

  # s.resource_bundles = {
  #   'TDPeopleStackView' => ['TDPeopleStackView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
