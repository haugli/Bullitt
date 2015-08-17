Pod::Spec.new do |s|

  s.name         = "Bullitt"
  s.version      = "0.0.1"
  s.summary      = "An iOS framework for interacting with the vBulletin API."

  s.description  = <<-DESC
                   Bullitt is a simple framework that provides access to the vBulletin mobile API.
                   
                   So far its feature set is limited:
                   * It can load the list of forums.
                   * It can load threads for a forum.
                   * It can load posts for a thread.
                   
                   Over time, it will be able to do more.
                   DESC

  s.homepage     = "https://github.com/haugli/Bullitt"
  
  s.license      = { :type => "MIT", :file => "LICENSE" }
  
  s.author             = "Chris Haugli"
  s.social_media_url   = "http://twitter.com/haugli"

  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  
  s.source       = { :git => "https://github.com/haugli/Bullitt.git", :tag => "#{s.version}" }
  s.source_files  = "Bullitt/*.swift"
  
  s.dependency 'Alamofire', '~> 1.3'
  s.dependency 'CryptoSwift', '~> 0.0.13'
  s.dependency 'SwiftyJSON', '~> 2.2.1'

end
