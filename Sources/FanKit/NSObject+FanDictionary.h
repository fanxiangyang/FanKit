//
//  NSObject+FanDictionary.h
//  FanKit
//
//  Created by 向阳凡 on 16/7/4.
//  Copyright © 2016年 凡向阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FanDictionary)
/**
 *  获得当前对象的所有成员变量列表，以字典返回
 *
 *  @return 字典
 */
- (NSMutableDictionary *)fan_modelToDictionary;
/**
 *  获得当前类及其父类的属性列表（递归法）
 *
 *  @param isSaveValue 是否保存属性值，当为NO时 Value=[NSNull null]
 *  @param depth       深度
 *
 *  @return 不同深度的属性列表
 */
-(NSMutableDictionary *)fan_propertyList:(BOOL)isSaveValue depth:(NSInteger)depth;
/**
 *  获得当前对象的所有属性列表
 *
 *  @param isSaveValue 返回的字典中的属性值是否保存属性值
 *
 *  @return 属性列表-字典
 */
- (NSMutableDictionary *)fan_propertyList:(BOOL)isSaveValue;

@end
