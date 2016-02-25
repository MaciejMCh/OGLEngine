//
//  Texture.m
//  jj
//
//  Created by Maciej Chmielewski on 21.02.2016.
//  Copyright © 2016 AppUnite. All rights reserved.
//

#import "Texture.h"

@interface Texture ()

@property (nonatomic, assign, readwrite) GLuint glName;
@property (nonatomic, strong) UIImage *image;

@end

@implementation Texture

- (instancetype)initWithImageNamed:(NSString *)imageName {
    self = [super init];
    if (self) {
        self.image = [UIImage imageNamed:imageName];
    }
    return self;
}

- (instancetype)initWithColor:(UIColor *)color {
    self = [super init];
    if (self) {
        self.image = [Texture imageWithColor:color];
    }
    return self;
}

- (void)bind {
    if (self.glName > 0) {
        return;
    }
    self.glName = [self bindTextureWithImage:self.image];
}

- (GLuint)bindTextureWithImage:(UIImage *)image {
    // 1
    NSAssert(image, @"Image not found");
    CGImageRef spriteImage = image.CGImage;
    
    // 2
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    // 4
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    return texName;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
