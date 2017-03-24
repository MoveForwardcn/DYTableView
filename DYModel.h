//
//  DYModel.h
//  DYTableView
//
//  Created by htkg on 17/3/8.
//  Copyright © 2017年 Uranus. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DYModel : NSObject
@property (nonatomic,copy)      NSString  *name;
@property (nonatomic,assign)    BOOL  isExpand; //标识是否是展开状态
@property (nonatomic,assign)    BOOL  hasLevel; //标识是否有子集
@property (nonatomic,copy)      NSMutableArray * list;
@end
