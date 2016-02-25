//
//  Drawable.m
//  jj
//
//  Created by Maciej Chmielewski on 14.02.2016.
//  Copyright © 2016 AppUnite. All rights reserved.
//

#import "Drawable.h"

@interface Drawable ()

@property (nonatomic, strong, readwrite) VAO *vao;
@property (nonatomic, strong, readwrite) id<GeometryModel> geometryModel;
@property (nonatomic, strong, readwrite) Texture *texture;

@end

@implementation Drawable

- (instancetype)initWithVao:(VAO *)vao
              geometryModel:(id<GeometryModel>)geometryModel
                    texture:(Texture *)texture {
    self = [super init];
    if (self) {
        self.vao = vao;
        self.geometryModel = geometryModel;
        self.texture = texture;
    }
    return self;
}

@end
