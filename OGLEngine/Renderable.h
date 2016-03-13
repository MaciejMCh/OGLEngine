//
//  Renderable.h
//  jj
//
//  Created by Maciej Chmielewski on 14.02.2016.
//  Copyright © 2016 AppUnite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VAO.h"
#import "GeometryModel.h"
#import "Texture.h"

@interface Renderable : NSObject

@property (nonatomic, strong, readonly) VAO *vao;
@property (nonatomic, strong, readonly) id<GeometryModel> geometryModel;
@property (nonatomic, strong, readonly) Texture *texture;

- (instancetype)initWithVao:(VAO *)vao
              geometryModel:(id<GeometryModel>)geometryModel
                    texture:(Texture *)texture;

@end
