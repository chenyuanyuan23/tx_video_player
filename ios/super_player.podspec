#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_super_player.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'super_player'
  s.version = '12.8.0'
  s.summary          = 'The super_player Flutter plugin is one of the sub-product SDKs of the audio/video terminal SDK (Tencent Cloud Video on Demand).'
  s.description      = <<-DESC
player plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => './LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.ios.framework = ['MobileCoreServices']
  s.platform = :ios, '12.0'
  s.static_framework = true
  s.resources = ['Classes/TXResource/**/*']

  # 自动寻找所有 xcframeworks
  tx_frameworks = 'tx_frameworks'
  tx_frameworks_version = '12.8.0.19666'
  # 添加这部分代码
  s.prepare_command = <<-CMD
  if [ ! -d #{tx_frameworks}/TXFFmpeg.xcframework ] || [ ! -d #{tx_frameworks}/TXLiteAVSDK_Player.xcframework ] || [ ! -d #{tx_frameworks}/TXSoundTouch.xcframework ]; then
      rm -rf #{tx_frameworks}
      mkdir -p #{tx_frameworks}
      timestamp=$(date +%s)
      curl -L -o LiteAVSDK_Player_iOS_#{tx_frameworks_version}.zip "https://github.com/chenyuanyuan23/librarys/raw/main/com/chenyuanyuan23/frameworks/LiteAVSDK_Player_iOS_#{tx_frameworks_version}.zip?t=$timestamp"
      unzip LiteAVSDK_Player_iOS_#{tx_frameworks_version}.zip -d #{tx_frameworks}
      rm -rf #{tx_frameworks}/TXLiteAVSDK_ReplayKitExt.xcframework
      rm -rf LiteAVSDK_Player_iOS_#{tx_frameworks_version}.zip
    fi
  CMD

  s.vendored_frameworks = [
    'localdep/FTXPiPKit.xcframework',
    "#{tx_frameworks}/*.xcframework"
  ]
      
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
