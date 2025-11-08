// Copyright (c) 2022 Tencent. All rights reserved.
part of SuperPlayer;

abstract class TXPlayerController {
  double? get resizeVideoWidth;
  double? get resizeVideoHeight;
  double? get videoLeft;
  double? get videoTop;
  double? get videoRight;
  double? get videoBottom;
  TXPlayerValue? playerValue();

  /// Get texture ID for Flutter texture rendering (iOS only)
  /// 获取用于 Flutter 纹理渲染的纹理 ID（仅 iOS）
  /// Returns -1 if using platform view mode or if not available
  /// 如果使用平台视图模式或不可用，则返回 -1
  Future<int> get textureId;

  /// Ensure texture ID is initialized for the given render mode
  /// 确保根据给定的渲染模式初始化纹理 ID
  ///
  /// This method is called by TXPlayerVideo widget to initialize texture on-demand
  /// 此方法由 TXPlayerVideo widget 调用以按需初始化纹理
  ///
  /// @param needTexture Whether texture mode is needed
  /// @return The texture ID, or -1 if not using texture mode
  Future<int> ensureTextureId(bool needTexture);

  @Deprecated("this method call will no longer be effective")
  Future<void> initialize({bool? onlyAudio});
  Future<bool> stop({bool isNeedClear = false});
  Future<bool> isPlaying();
  Future<void> pause();
  Future<void> resume();
  Future<void> setMute(bool mute);
  Future<bool> enableHardwareDecode(bool enable);
  Future<int> enterPictureInPictureMode(
      {String? backIconForAndroid, String? playIconForAndroid, String? pauseIconForAndroid, String? forwardIconForAndroid});
  Future<void> exitPictureInPictureMode();
  Future<void> setPlayerView(int renderViewId);
  Future<void> setRenderMode(FTXPlayerRenderMode renderMode);
  Future<void> dispose();
}