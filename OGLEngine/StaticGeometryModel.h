//
//  StaticGeometryModel.h
//  jj
//
//  Created by Maciej Chmielewski on 14.02.2016.
//  Copyright © 2016 AppUnite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeometryModel.h"

@interface StaticGeometryModel : NSObject<GeometryModel>

- (instancetype)initWithModelMatrix:(GLKMatrix4)modelMatrix;

@end
