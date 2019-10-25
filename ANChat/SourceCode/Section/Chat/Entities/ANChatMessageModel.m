//
//  ANChatMessageModel.m
//  ANChat
//
//  Created by liuyunpeng on 2019/5/30.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANChatMessageModel.h"

@implementation ANChatMessageModel
+ (NSDictionary<NSString *,id> *)propertyToKeyPair {
    return @{@"fromId"           : @"book_id",
             @"messageId"           : @"tid",
             @"sourceUrl"           : @"url",
             };
}

+ (NSString *) primaryKey {
    return @"messageId";
}
+ (NSArray *)ignoredProperties {
    return @[];
}
- (NSString *)uniqueCode
{
    return [NSString stringWithFormat:@"%@-%@",NSStringFromClass([self class]),self.messageId];
}

-(NSString*)typeStr
{
    switch ([self.type integerValue]) {
        case ANMessageType_Pic:
            return Msg_TypePic;
            break;
        case ANMessageType_Pic_Lock:
            return Msg_TypePriPic;
            break;
        case ANMessageType_Text:
            return Msg_TypeText;
            break;
        case ANMessageType_Voice:
            return Msg_TypeVoice;
            break;
        case ANMessageType_Video:
            return Msg_TypeVideo;
            break;
        case ANMessageType_Video_Lock:
            return Msg_TypePriVideo;
            break;
        case ANMessageType_Gift:
            return Msg_TypeGift;
            break;
        case ANMessageType_Link:
            return Msg_TypeLink;
            break;
        case ANMessageType_Dynamic:
            return Msg_TypeGif;
            break;
        default:
            break;
    }
    return nil;
}
@end
