Pod::Spec.new do |s|
  s.name     = 'BSSegmentPagingView'
  s.version  = '0.0.2'
  s.summary = 'An paging view for iOS'
  s.license = { :type => 'MIT', :file => 'LICENCE' }
  s.homepage = 'https://github.com/juxingzhutou/BSSegmentPagingView'
  s.author = { 'juxingzhutou' => 'juxingzhutou@gmail.com' }

  s.platform = :ios
  s.ios.deployment_target = '7.0'
  s.requires_arc = true

  s.source = { :git => "https://github.com/juxingzhutou/BSSegmentPagingView.git", :tag => 'v0.0.2' }
  s.source_files = "BSSegmentPagingView/*.{h,m}"
  s.public_header_files = "BSSegmentPagingView/BSSegmentPagingView.h"

  s.dependency "Masonry", "~>0.6.2"

end
