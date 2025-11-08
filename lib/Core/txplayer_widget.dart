// Copyright (c) 2022 Tencent. All rights reserved.
part of SuperPlayer;

typedef FTXOnRenderViewCreatedListener = void Function(int viewId);

class TXPlayerVideo extends StatefulWidget {

  final FTXAndroidRenderViewType renderViewType;
  final FTXOnRenderViewCreatedListener? onRenderViewCreatedListener;

  /// Controller for texture mode (iOS only)
  /// Texture 模式使用的控制器（仅 iOS）
  ///
  /// **iOS Texture Mode**: When iosRenderMode is set to TEXTURE,
  /// you must pass the controller to enable texture rendering.
  ///
  /// **iOS Texture 模式**: 当 iosRenderMode 设置为 TEXTURE 时，
  /// 必须传入 controller 以启用纹理渲染。
  final TXPlayerController? controller;

  /// iOS rendering mode (per-widget configuration)
  /// iOS 渲染模式（每个 widget 独立配置）
  ///
  /// Defaults to PLATFORM_VIEW if not specified
  /// 如果未指定，默认为 PLATFORM_VIEW
  final FTXIOSRenderMode iosRenderMode;

  ///
  /// 从 12.4.1 版本开始，移除传入 controller 的绑定纹理方式，该方式由于不可预见问题太多，所以移除。推荐使用 TXPlayerVideo
  /// 的 onRenderViewCreatedListener 回调，在获取到 viewId 后，使用 controller#setPlayerView 进行播放器和纹理的绑定
  ///
  /// Starting from version 12.4.1, the method of binding textures by passing in a controller has been removed.
  /// This method is removed due to too many unforeseen issues. It is recommended to use the `onRenderViewCreatedListener`
  /// callback of `TXPlayerVideo`. After obtaining the `viewId`, use `controller#setPlayerView` to bind the player
  /// and texture.
  ///
  /// e.g:
  /// TXPlayerVideo(
  ///    onRenderViewCreatedListener: (viewId) {
  ///      /// 此处只展示了最基础的纹理和播放器的配置方式。 这里可记录下来 viewId，在多纹理之间进行切换，比如横竖屏切换场景，竖屏的画面，
  ///      /// 要切换到横屏的画面，可以在切换到横屏之后， 拿到横屏的viewId 设置上去。回到竖屏的时候，再通过 viewId 切换回来。
  ///      /// Only the most basic configuration methods for textures and the player are shown here.
  ///      /// The `viewId` can be recorded here to switch between multiple textures. For example, in the scenario
  ///      /// of switching between portrait and landscape orientations:
  ///      /// To switch from the portrait view to the landscape view, obtain the `viewId` of the landscape view
  ///      /// after switching to landscape orientation and set it.  When switching back to portrait orientation,
  ///      /// switch back using the recorded `viewId`.
  ///      _controller.setPlayerView(viewId);
  ///    },
  ///  )
  ///
  TXPlayerVideo({
    this.onRenderViewCreatedListener,
    this.controller,
    this.iosRenderMode = FTXIOSRenderMode.PLATFORM_VIEW,
    FTXAndroidRenderViewType? androidRenderType,
    Key? viewKey,
  })  : renderViewType =
            androidRenderType ?? FTXAndroidRenderViewType.TEXTURE_VIEW,
        super(key: viewKey);

  @override
  TXPlayerVideoState createState() => TXPlayerVideoState();
}

class TXPlayerVideoState extends State<TXPlayerVideo> {
  static const TAG = "TXPlayerVideo";

  int _viewId = -1;
  int _textureId = -1;
  Completer<int> _viewIdCompleter = Completer();
  // for force rebuild
  Key _platformViewKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    if (_shouldUseTextureMode()) {
      _initTextureMode();
    }
  }

  @override
  void didUpdateWidget(covariant TXPlayerVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
   if (oldWidget.renderViewType != widget.renderViewType) {
      setState(() {
        _platformViewKey = UniqueKey();
      });
    }
  }

  /// Check if should use texture mode for current platform and configuration
  /// 检查是否应该使用纹理模式
  bool _shouldUseTextureMode() {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      return false;
    }
    // Use per-widget configuration
    return widget.iosRenderMode == FTXIOSRenderMode.TEXTURE;
  }

  /// Initialize texture mode by getting texture ID from controller
  /// 通过从控制器获取纹理 ID 来初始化纹理模式
  void _initTextureMode() async {
    if (widget.controller != null) {
      try {
        // Call ensureTextureId to initialize texture on-demand
        final textureId = await widget.controller!.ensureTextureId(true);
        LogUtils.d(TAG, "📱 Widget got textureId: $textureId");
        if (mounted && textureId != _textureId) {
          setState(() {
            _textureId = textureId;
          });
        }
      } catch (e) {
        LogUtils.e(TAG, "❌ Failed to initialize texture mode: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _buildAndroidView();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      if (_shouldUseTextureMode()) {
        return _buildIOSTexture();
      } else {
        return _buildIOSPlatformView();
      }
    } else {
      throw ArgumentError("platform not support: $defaultTargetPlatform");
    }
  }

  /// Build Android platform view
  /// 构建 Android 平台视图
  Widget _buildAndroidView() {
    return IgnorePointer(
        ignoring: true,
        child: AndroidView(
          key: _platformViewKey,
          onPlatformViewCreated: _onCreateAndroidView,
          viewType: _kFTXPlayerRenderViewType,
          layoutDirection: TextDirection.ltr,
          creationParams: {
            _kFTXAndroidRenderTypeKey: widget.renderViewType.index
          },
          creationParamsCodec: const StandardMessageCodec(),
        ));
  }

  /// Build iOS platform view (UiKitView mode)
  /// 构建 iOS 平台视图（UiKitView 模式）
  Widget _buildIOSPlatformView() {
    return IgnorePointer(
      ignoring: true,
      child: UiKitView(
          key: _platformViewKey,
          viewType: _kFTXPlayerRenderViewType,
          layoutDirection: TextDirection.ltr,
          creationParams: const {},
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: _onCreateIOSView),
    );
  }

  /// Build iOS texture view (Texture mode)
  /// 构建 iOS 纹理视图（Texture 模式）
  Widget _buildIOSTexture() {
    if (_textureId == -1) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            'Initializing texture...',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    // Support rotation
    var degree = widget.controller?.playerValue()?.degree ?? 0;
    var quarterTurns = (degree / 90).floor();

    if (quarterTurns == 0) {
      return Texture(textureId: _textureId);
    } else {
      return RotatedBox(
        quarterTurns: -quarterTurns,
        child: Texture(textureId: _textureId),
      );
    }
  }

  void _onCreateAndroidView(int id) {
    if (_viewIdCompleter.isCompleted) {
      _viewIdCompleter = Completer();
    }
    _viewId = id;
    _viewIdCompleter.complete(id);
    widget.onRenderViewCreatedListener?.call(id);
  }

  void _onCreateIOSView(int id) {
    if (_viewIdCompleter.isCompleted) {
      _viewIdCompleter = Completer();
    }
    _viewId = id;
    _viewIdCompleter.complete(id);
    widget.onRenderViewCreatedListener?.call(id);
  }

  Future<int> getViewId() async {
    await _viewIdCompleter.future;
    return _viewId;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
