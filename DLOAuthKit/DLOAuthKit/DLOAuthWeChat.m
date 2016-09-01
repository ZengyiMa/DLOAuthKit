//
//  DLOAuthWeChat.m
//  Niupu_SNS
//
//  Created by famulei on 8/31/16.
//  Copyright © 2016 WE. All rights reserved.
//

#import "DLOAuthWeChat.h"

@implementation DLOAuthWeChat

- (BOOL)registerSDKWithConfigure:(NSDictionary *)configure
{
    return [WXApi registerApp:kWeChatOAuthAppID];
}

- (void)authorize
{
    SendAuthReq *request = [[SendAuthReq alloc] init];
    request.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
    request.state = @"wechat_auth_login_mazengyi";
    [WXApi sendReq:request];

}

- (BOOL)handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)onResp:(BaseResp *)resp
{
    if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        if (authResp.code) {
            [self getWeChatAccessTokenWithCode:authResp.code];
        }
        else
        {
            [[DLOAuthKit sharedInstance]authorizeCompletedWithUser:nil statusCode:authResp.code.integerValue errorMessage:@"授权失败"];
        }
    }
}

- (void)getWeChatAccessTokenWithCode:(NSString *)code
{
    
    NSDictionary *parms = @{@"appid": kWeChatOAuthAppID,
             @"secret": kWeChatOAuthSecret,
             @"code": code,
             @"grant_type": @"authorization_code"};
    
    [self requestWeChatWithURL:@"https://api.weixin.qq.com/sns/oauth2/access_token" parms:parms completetionHandler:^(NSDictionary *result) {
        NSString *openId = result[@"openid"];
        NSString *accessToken = result[@"access_token"];
        if (openId && accessToken) {
            [self requestWeChatWithURL:@"https://api.weixin.qq.com/sns/userinfo"
                                 parms:@{@"openid": openId,@"access_token": accessToken}
                   completetionHandler:^(NSDictionary *result) {
                       if (result) {
                           DLOAuthUser *user = [[DLOAuthUser alloc] init];
                           user.userID = result[@"unionid"];
                           user.gender = result[@"sex"];
                           user.nickName = result[@"nickname"];
                           user.avatar = result[@"headimgurl"];
                           user.originObject = result;
                           user.accessToken = accessToken;
                           [[DLOAuthKit sharedInstance]authorizeCompletedWithUser:user statusCode:0 errorMessage:@""];
                       }
                       else
                       {
                           [[DLOAuthKit sharedInstance]authorizeCompletedWithUser:nil statusCode:-1 errorMessage:@"获取userinfo失败，失败URL:https://api.weixin.qq.com/sns/userinfo"];
                       }
                   }
             ];
        }
        else
        {
               [[DLOAuthKit sharedInstance]authorizeCompletedWithUser:nil statusCode:-1 errorMessage:@"获取access_token失败，失败URL:https://api.weixin.qq.com/sns/oauth2/access_token"];
        }
    }];
    
    
    
}



- (void)requestWeChatWithURL:(NSString *)URL parms:(NSDictionary *)parms completetionHandler:(void(^)(NSDictionary *result))handler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self urlAppendParms:parms ofURL:URL]]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json; charset=utf8" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
             if (data != nil)
             {
                 id result = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:&error];
                 if (handler) {
                     handler(result);
                 }
             }
             else
             {
                 if (handler) {
                     handler(nil);
                 }
             }
         }];
    
    [task resume];

}


- (NSString *)urlAppendParms:(NSDictionary *)parms ofURL:(NSString *)URL
{
    NSString *url = URL;
    BOOL isFirst = YES;
    for (NSString *key in parms.allKeys) {
        NSString *keyAndValues = [NSString stringWithFormat:@"%@=%@", key, parms[key]];
        if (isFirst) {
            isFirst = NO;
            url = [url stringByAppendingString:[NSString stringWithFormat:@"?%@", keyAndValues]];
        }
        else
        {
            url = [url stringByAppendingString:[NSString stringWithFormat:@"&%@", keyAndValues]];
        }
    }
    return url;
}








@end
