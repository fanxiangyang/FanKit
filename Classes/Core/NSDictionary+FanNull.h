//
//  NSDictionary+FanNull.h
//  FanKYUnity
//
//  Created by 向阳凡 on 16/7/28.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger,FanObject) {
    FanObjectString=0,
    FanObjectNumber,
    FanObjectArray,
    FanObjectDictionary
};


@interface NSDictionary (FanNull)



-(id)fan_objectForKey:(id)aKey;
-(id)fan_objectForKey:(id)aKey type:(FanObject)objType;



@end
