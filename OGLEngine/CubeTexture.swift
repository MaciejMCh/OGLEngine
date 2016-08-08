//
//  CubeTexture.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 08.08.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import GLKit

enum CubeTextureSide {
    case NegativeX
    case PositiveX
    case NegativeY
    case PositiveY
    case NegativeZ
    case PositiveZ
    
    func glEnum() -> GLenum {
        switch self {
        case .NegativeX: return GLenum(GL_TEXTURE_CUBE_MAP_NEGATIVE_X)
        case .PositiveX: return GLenum(GL_TEXTURE_CUBE_MAP_POSITIVE_X)
        case .NegativeY: return GLenum(GL_TEXTURE_CUBE_MAP_NEGATIVE_Y)
        case .PositiveY: return GLenum(GL_TEXTURE_CUBE_MAP_POSITIVE_Y)
        case .NegativeZ: return GLenum(GL_TEXTURE_CUBE_MAP_NEGATIVE_Z)
        case .PositiveZ: return GLenum(GL_TEXTURE_CUBE_MAP_POSITIVE_Z)
        }
    }
}

public class CubeTexture {
    var glName: GLuint = 0
    
    init() {
        // Create
        var glName = GLuint()
        glGenTextures(1, &glName)
        glBindTexture(GLenum(GL_TEXTURE_CUBE_MAP), glName)
        self.glName = glName
    }
    
    func testColorBindings() {
        bindTextureWithImage(ImageTexture.imageWithColor(UIColor.redColor()), side: .NegativeX)
        bindTextureWithImage(ImageTexture.imageWithColor(UIColor.magentaColor()), side: .PositiveX)
        bindTextureWithImage(ImageTexture.imageWithColor(UIColor.blueColor()), side: .NegativeY)
        bindTextureWithImage(ImageTexture.imageWithColor(UIColor.cyanColor()), side: .PositiveY)
        bindTextureWithImage(ImageTexture.imageWithColor(UIColor.greenColor()), side: .NegativeZ)
        bindTextureWithImage(ImageTexture.imageWithColor(UIColor.yellowColor()), side: .PositiveZ)
        
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST)
    }
    
    func bindTextureWithImage(image: UIImage, side: CubeTextureSide) {
        let spriteImage: CGImageRef = image.CGImage!
        let width: size_t = CGImageGetWidth(spriteImage)
        let height: size_t = CGImageGetHeight(spriteImage)
        let spriteData = calloc(width * height * 4, sizeof(GLubyte))
        let spriteContext: CGContextRef = CGBitmapContextCreate(spriteData, width, height, 8, width * 4, CGImageGetColorSpace(spriteImage), CGImageAlphaInfo.PremultipliedLast.rawValue)!
        CGContextDrawImage(spriteContext, CGRectMake(0, 0, CGFloat(width), CGFloat(height)), spriteImage)
        glTexImage2D(side.glEnum(), 0, GL_RGBA, GLsizei(width), GLsizei(height), 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), spriteData)
        free(spriteData)
    }
}
