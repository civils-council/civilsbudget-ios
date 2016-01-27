#
# Be sure to run `pod lib lint BankIdSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "BankIdSDK"
  s.version          = "0.1.0"
  s.summary          = "Easy and quick way to access Ukrainian BankId System"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
                        To be delivered...
                       DESC

  s.homepage         = "https://github.com/<GITHUB_USERNAME>/BankIdSDK"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Max Odnovolyk" => "modnovolyk@gmail.com" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/BankIdSDK.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'BankIdSDK/Library/BankIdSDK/Classes/**/*'
  s.resources = 'BankIdSDK/Library/BankIdSDK/Resources/**/*'
  # s.public_header_files = 'BankIdSDK/Library/BankIdSDK/Supporting Files/BankIdSDK.h'
  s.dependency    'Alamofire',       '~> 3.1'
end
