//
//  SpinningGeometryModel.h
//  jj
//
//  Created by Maciej Chmielewski on 17.02.2016.
//  Copyright © 2016 AppUnite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OGLEngine-Swift.h"

@interface SpinningGeometryModel : NSObject<GeometryModel>

- (instancetype)initWithPosition:(GLKVector3)position;

@end
