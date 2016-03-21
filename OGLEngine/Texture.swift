//
//  Texture.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation

public class Texture : NSObject {
    
    var image : UIImage!
    public var glName : GLuint = 0
    
    convenience init(imageNamed imageName: String) {
        self.init()
        self.image = UIImage(named: imageName)
    }
    
    convenience init(color: UIColor) {
        self.init()
        self.image = Texture.imageWithColor(color)
    }
    
    func bind() {
        if self.glName > 0 {
            return
        }
        self.glName = self.bindTextureWithImage(self.image)
    }
    
    func bindTextureWithImage(image: UIImage) -> GLuint {
        // 1
        var spriteImage: CGImageRef = image.CGImage!
        // 2
        var width: size_t = CGImageGetWidth(spriteImage)
        var height: size_t = CGImageGetHeight(spriteImage)
        var spriteData = calloc(width * height * 4, sizeof(GLubyte))
        var spriteContext: CGContextRef = CGBitmapContextCreate(spriteData, width, height, 8, width * 4, CGImageGetColorSpace(spriteImage), CGImageAlphaInfo.PremultipliedLast.rawValue)!
        // 3
        CGContextDrawImage(spriteContext, CGRectMake(0, 0, CGFloat(width), CGFloat(height)), spriteImage)
//        CGContextRelease(spriteContext)
        // 4
        var texName: GLuint = 0
        glGenTextures(1, &texName)
        glBindTexture(GLenum(GL_TEXTURE_2D), texName)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST)
        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, GLsizei(width), GLsizei(height), 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), spriteData)
        free(spriteData)
        return texName
    }
    
    class func imageWithColor(color: UIColor) -> UIImage {
        var rect: CGRect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        var context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}