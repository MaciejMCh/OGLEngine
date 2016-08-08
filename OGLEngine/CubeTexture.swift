//
//  CubeTexture.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 08.08.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import GLKit

public struct CubeTexture {
    var glName: GLuint = 0
    
    init() {
        // Create
        var glName = GLuint()
        glGenTextures(1, &glName)
        glBindTexture(GLenum(GL_TEXTURE_CUBE_MAP), glName)
        self.glName = glName
        
        bindTextureWithImage(ImageTexture.imageWithColor(UIColor.redColor()), side: GLenum(GL_TEXTURE_CUBE_MAP_NEGATIVE_X)) // LT
        bindTextureWithImage(ImageTexture.imageWithColor(UIColor.magentaColor()), side: GLenum(GL_TEXTURE_CUBE_MAP_POSITIVE_Y)) // FT
        bindTextureWithImage(ImageTexture.imageWithColor(UIColor.blueColor()), side: GLenum(GL_TEXTURE_CUBE_MAP_POSITIVE_X)) // RT
        bindTextureWithImage(ImageTexture.imageWithColor(UIColor.cyanColor()), side: GLenum(GL_TEXTURE_CUBE_MAP_NEGATIVE_Y)) // BK
        bindTextureWithImage(ImageTexture.imageWithColor(UIColor.greenColor()), side: GLenum(GL_TEXTURE_CUBE_MAP_POSITIVE_Z)) // UP
        bindTextureWithImage(ImageTexture.imageWithColor(UIColor.yellowColor()), side: GLenum(GL_TEXTURE_CUBE_MAP_NEGATIVE_Z)) // DN
        
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST)
    }
    
    func bindTextureWithImage(image: UIImage, side: GLenum) {
        // 1
        let spriteImage: CGImageRef = image.CGImage!
        // 2
        let width: size_t = CGImageGetWidth(spriteImage)
        let height: size_t = CGImageGetHeight(spriteImage)
        let spriteData = calloc(width * height * 4, sizeof(GLubyte))
        let spriteContext: CGContextRef = CGBitmapContextCreate(spriteData, width, height, 8, width * 4, CGImageGetColorSpace(spriteImage), CGImageAlphaInfo.PremultipliedLast.rawValue)!
        // 3
        CGContextDrawImage(spriteContext, CGRectMake(0, 0, CGFloat(width), CGFloat(height)), spriteImage)
        //        CGContextRelease(spriteContext)
        // 4
//        var texName: GLuint = 0
//        glGenTextures(1, &texName)
//        glBindTexture(GLenum(GL_TEXTURE_2D), texName)
        
        glTexImage2D(side, 0, GL_RGBA, GLsizei(width), GLsizei(height), 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), spriteData)
        free(spriteData)
    }
}
