//
//  DLOAuthQQ.m
//  Niupu_SNS
//
//  Created by famulei on 9/1/16.
//  Copyright © 2016 WE. All rights reserved.
//

#import "DLOAuthQQ.h"

@implementation DLOAuthQQ
- (BOOL)registerSDKWithConfigure:(NSDictionary *)configure
{
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:kQQOAuthAppID andDelegate:self];
    return YES;
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    return [TencentOAuth HandleOpenURL:url];
}

- (void)authorize
{
    [self.tencentOAuth authorize:@[kOPEN_PERMISSION_ADD_TOPIC,
                                   kOPEN_PERMISSION_ADD_ONE_BLOG,
                                   kOPEN_PERMISSION_ADD_ALBUM,
                                   kOPEN_PERMISSION_UPLOAD_PIC,
                                   kOPEN_PERMISSION_LIST_ALBUM,
                                   kOPEN_PERMISSION_ADD_SHARE,
                                   kOPEN_PERMISSION_CHECK_PAGE_FANS,
                                   kOPEN_PERMISSION_GET_INFO,
                                   kOPEN_PERMISSION_GET_OTHER_INFO,
                                   kOPEN_PERMISSION_GET_VIP_INFO,
                                   kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                                   kOPEN_PERMISSION_GET_USER_INFO,
                                   kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]
                        inSafari:YES];
}

#pragma mark - QQ delegate
- (void)tencentDidLogin
{
    [self.tencentOAuth getUserInfo];
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    [[DLOAuthKit sharedInstance]authorizeCompletedWithUser:nil statusCode:-1 errorMessage:cancelled ? @"用户取消登录":@"登录失败"];

}

- (void)tencentDidNotNetWork
{
    [[DLOAuthKit sharedInstance]authorizeCompletedWithUser:nil statusCode:-1 errorMessage:@"网络连接失败"];
}

- (void)getUserInfoResponse:(APIResponse *)response
{
    if (response.retCode == URLREQUEST_SUCCEED)
    {
        NSDictionary *jsonResp = response.jsonResponse;
        if (self.tencentOAuth.openId)
        {
            DLOAuthUser *user = [DLOAuthUser new];
            user.userID = self.tencentOAuth.openId;
            user.nickName = jsonResp[@"nickname"];
            user.gender = jsonResp[@"gender"];
            user.avatar = jsonResp[@"figureurl_qq_2"];
            user.accessToken = self.tencentOAuth.accessToken;
            user.originObject = response;
            [[DLOAuthKit sharedInstance]authorizeCompletedWithUser:user statusCode:URLREQUEST_SUCCEED errorMessage:@""];
        }
        else
        {
           [[DLOAuthKit sharedInstance]authorizeCompletedWithUser:nil statusCode:response.retCode errorMessage:response.errorMsg];
        }
    }
    else
    {
        [[DLOAuthKit sharedInstance]authorizeCompletedWithUser:nil statusCode:response.retCode errorMessage:response.errorMsg];

    }

}






@end
