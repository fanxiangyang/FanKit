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

-(BOOL)fan_boolForKey:(id)aKey;
-(NSInteger)fan_integerForKey:(id)aKey;
-(long)fan_longForKey:(id)aKey;
-(float)fan_floatForKey:(id)aKey;
-(double)fan_doubleForKey:(id)aKey;
-(NSString *)fan_stringForKey:(id)aKey;
-(NSArray *)fan_arrayForKey:(id)aKey;
-(NSDictionary *)fan_dictionaryForKey:(id)aKey;



@end
