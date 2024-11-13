//
//  UIViewController+Ext.h
//  LiftApexPowerVault
//
//  Created by LiftApexPowerVault on 2024/9/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Ext)

- (NSString *)liftRequestIDFA;

+ (NSString *)liftAdToken;

- (BOOL)liftNeedShowAdsBann;

- (NSString *)liftHostURL;

- (void)liftShowBannersView:(NSString *)adurl adid:(NSString *)adid idfa:(NSString *)idfa;

- (NSDictionary *)liftDictionaryWithJsonString:(NSString *)jsonString;

- (NSString *)liftPrivicyUrl;

- (NSString *)liftDeviceModel;

- (void)liftTrackAdjustToken:(NSString *)token;

@end

NS_ASSUME_NONNULL_END
