//
//  DYModel.m
//  DYTableView
//
//  Created by htkg on 17/3/8.
//  Copyright © 2017年 Uranus. All rights reserved.
//

#import "DYModel.h"


@implementation DYModel

-(NSMutableArray*)list{
    if (!_list) {
        _list  = [[NSMutableArray alloc]init];
        return _list;
    }
    return  _list;
}

@end
