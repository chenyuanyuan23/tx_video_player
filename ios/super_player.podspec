#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_super_player.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'super_player'
  s.version          = '11.9.1'
  s.summary          = 'player plugin.'
  s.description      = <<-DESC
player plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.ios.framework = ['MobileCoreServices']
  s.platform = :ios, '9.0'
  s.static_framework = true
  s.resources = ['Classes/TXResource/**/*']

  # 自动寻找所有 xcframeworks
  frameworks_dir = 'libs'
  version = '12.3.0.16995'
  # 添加这部分代码
  s.prepare_command = <<-CMD
    if [ ! -d libs/TXFFmpeg.xcframework ] || [ ! -d libs/TXLiteAVSDK_Player.xcframework ] || [ ! -d libs/TXSoundTouch.xcframework ]; then
      rm -rf libs
      mkdir -p libs
      curl -L -o LiteAVSDK_Player_iOS_#{version}.zip https://github.com/chenyuanyuan23/librarys/raw/main/com/chenyuanyuan23/frameworks/LiteAVSDK_Player_iOS_#{version}.zip
      unzip LiteAVSDK_Player_iOS_#{version}.zip -d libs
      rm -rf libs/TXLiteAVSDK_ReplayKitExt.xcframework
      rm -rf LiteAVSDK_Player_iOS_#{version}.zip
    fi
  CMD

  s.vendored_frameworks = 
      "#{frameworks_dir}/*.xcframework"
      
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 armv7',
    'OTHER_LDFLAGS' => '$(inherited) -ObjC',
    'HEADER_SEARCH_PATHS' => '${PODS_ROOT}/../TXLiteAVSDK_Player.framework/Headers',
    'FRAMEWORK_SEARCH_PATHS' => '${PODS_ROOT}/..',
    # 'VALID_ARCHS' => 'arm64',
  }

end
