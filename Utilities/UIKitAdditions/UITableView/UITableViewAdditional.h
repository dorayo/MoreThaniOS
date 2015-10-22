//
//  UITableViewAdditional.h
//
//  Created by jiwei on 14/12/4.
//  Copyright (c) 2014年 weiji. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  UITableView的一个将IndexPath和Index相互转化的扩展
 */

@interface UITableView (Index)

-(NSInteger)index4IndexPath:(NSIndexPath *)indexPath;

@end
