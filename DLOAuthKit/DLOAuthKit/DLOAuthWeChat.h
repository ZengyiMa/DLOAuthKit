//
//  DLOAuthWeChat.h
//  Niupu_SNS
//
//  Created by famulei on 8/31/16.
//  Copyright © 2016 WE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLOAuthProtocol.h"
#import "WXApi.h"


@interface DLOAuthWeChat : NSObject<DLOAuthProtocol, WXApiDelegate>

@end
