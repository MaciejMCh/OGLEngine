//
//  Camera.h
//  jj
//
//  Created by Maciej Chmielewski on 14.02.2016.
//  Copyright © 2016 AppUnite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@protocol Camera <NSObject>

- (GLKMatrix4)viewProjectionMatrix;
- (GLKVector3)cameraPosition;

@end
