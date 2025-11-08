// Copyright (c) 2022 Tencent. All rights reserved.
part of SuperPlayer;

abstract class FPlayerPckInfo {
  static const String PLAYER_VERSION = "12.8.1";
}

/// iOS rendering mode configuration
/// iOS 渲染模式配置
enum FTXIOSRenderMode {
  /// Use platform view (UiKitView) - Default mode
  /// 使用平台视图 (UiKitView) - 默认模式
  PLATFORM_VIEW,

  /// Use texture rendering - Better performance, supports BackdropFilter and Flutter composition effects
  /// 使用纹理渲染 - 更好的性能，支持 BackdropFilter 和 Flutter 合成效果
  TEXTURE,
}