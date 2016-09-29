//
//  DLOAuthWeibo.m
//  Niupu_SNS
//
//  Created by famulei on 8/30/16.
//  Copyright © 2016 WE. All rights reserved.
//

#import "DLOAuthWeibo.h"

@implementation DLOAuthWeibo


- (BOOL)registerSDKWithConfigure:(NSDictionary *)configure
{
    return [WeiboSDK registerApp:kWeiboOAuthAppID];
}

- (void)authorize
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kWeiboOAuthRedirectUrl;
    request.scope = @"all";
    request.userInfo = @{@"request_from": @"auth"};
    request.shouldShowWebViewForAuthIfCannotSSO = YES;
    [WeiboSDK sendRequest:request];
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

#pragma amrk - Weibo delegate

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:[WBAuthorizeResponse class]])
    {
        NSString *token = [(WBAuthorizeResponse *)response accessToken];
        NSString *userID = [(WBAuthorizeResponse *)response userID];
        [WBHttpRequest requestForUserProfile:userID
                             withAccessToken:token
                          andOtherProperties:nil
                                       queue:nil
                       withCompletionHandler:^(WBHttpRequest *httpRequest,  WeiboUser *user, NSError *error) {
                           DLOAuthUser *dlUser = [self userFromWBUser:user];
                           dlUser.accessToken = token;
                           [[DLOAuthKit sharedInstance]authorizeCompletedWithUser:dlUser statusCode:response.statusCode errorMessage:@"暂时未实现错误消息"];
                        }];
    }
}



- (DLOAuthUser *)userFromWBUser:(WeiboUser *)user
{
    DLOAuthUser *dlUser = [DLOAuthUser new];
    dlUser.userID = user.userID;
    dlUser.nickName = user.screenName;
    dlUser.avatar = user.avatarHDUrl;
    dlUser.gender = user.gender;
    dlUser.originObject = user;
    return dlUser;
}



@end
