//
//  DLOAuthWeibo.h
//  Niupu_SNS
//
//  Created by famulei on 8/30/16.
//  Copyright © 2016 WE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLOAuthProtocol.h"
#import "WeiboSDK.h"
#import "WeiboUser.h"

@interface DLOAuthWeibo : NSObject<DLOAuthProtocol, WeiboSDKDelegate>

@end
