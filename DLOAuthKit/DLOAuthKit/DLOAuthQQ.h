//
//  DLOAuthQQ.h
//  Niupu_SNS
//
//  Created by famulei on 9/1/16.
//  Copyright © 2016 WE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLOAuthProtocol.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface DLOAuthQQ : NSObject<DLOAuthProtocol, TencentSessionDelegate>
@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@end
