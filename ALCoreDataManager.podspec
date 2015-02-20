#
# Be sure to run `pod lib lint ALCoreDataManager.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ALCoreDataManager"
  s.version          = "0.1.3"
  s.summary          = "Fast and easy way to get NSManagedObjectContext"
  s.description      = <<-DESC
                       Singleton class for getting NSManagedObjectContext in single Model apps fast and easy.

                       * Just set the ModelName in your AppDelegate
                       * Done!
                       DESC
  s.homepage         = "https://github.com/appleios/ALCoreDataManager"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Aziz U. Latypov" => "vm06lau@mail.ru" }
  s.source           = { :git => "https://github.com/appleios/ALCoreDataManager.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  # s.resources = 'Pod/Assets/*.png'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'CoreData', 'Foundation'
  # s.dependency 'AFNetworking', '~> 2.3'
end
