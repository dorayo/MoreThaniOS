//
//  UITableViewAdditional.m
//
//  Created by jiwei on 14/12/4.
//  Copyright (c) 2014年 weiji. All rights reserved.
//

#import "UITableViewAdditional.h"

@implementation UITableView (Index)

-(NSInteger)index4IndexPath:(NSIndexPath *)indexPath{
    NSInteger index = 0;
    for (int i = 0; i< indexPath.section; i++) {
        index += [self numberOfRowsInSection:i];
    }
    index += indexPath.row;
    return index;
}

@end
