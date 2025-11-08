// Copyright (c) 2022 Tencent. All rights reserved.
#ifndef SUPERPLAYER_FLUTTER_IOS_CLASSES_PLAYER_FTXLIVEPLAYER_H_
#define SUPERPLAYER_FLUTTER_IOS_CLASSES_PLAYER_FTXLIVEPLAYER_H_

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "FTXBasePlayer.h"
#import "FTXVodPlayerDelegate.h"
#import "FTXRenderViewFactory.h"

@protocol FlutterPluginRegistrar;

NS_ASSUME_NONNULL_BEGIN

@interface FTXLivePlayer : FTXBasePlayer<FlutterTexture>

@property(nonatomic, weak) id<FTXVodPlayerDelegate> delegate;

- (instancetype)initWithRegistrar:(id<FlutterPluginRegistrar>)registrar
                renderViewFactory:(FTXRenderViewFactory*)renderViewFactory
                        onlyAudio:(BOOL)onlyAudio;

- (void)notifyAppTerminate:(UIApplication *)application;

/// Get texture ID for Flutter texture rendering
/// 获取纹理 ID 用于 Flutter 纹理渲染
- (int64_t)getTextureId;

@end

NS_ASSUME_NONNULL_END

#endif  // SUPERPLAYER_FLUTTER_IOS_CLASSES_PLAYER_FTXLIVEPLAYER_H_
