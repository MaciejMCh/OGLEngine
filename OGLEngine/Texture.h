//
//  Texture.h
//  jj
//
//  Created by Maciej Chmielewski on 21.02.2016.
//  Copyright © 2016 AppUnite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/glext.h>

@interface Texture : NSObject

@property (nonatomic, assign, readonly) GLuint glName;

- (instancetype)initWithImageNamed:(NSString *)imageName;
- (instancetype)initWithColor:(UIColor *)color;

- (void)bind;

@end
