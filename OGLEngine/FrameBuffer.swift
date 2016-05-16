//
//  FrameBuffer.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 13.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

struct RenderOutputTexture {
    let width: GLsizei = 400
    let height: GLsizei = 400
    
    init() {
        // Create the framebuffer and bind it.
        var framebuffer: GLuint = 0
        glGenFramebuffers(1, &framebuffer)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), framebuffer)
        // Create a color renderbuffer, allocate storage for it, and attach it to the framebuffer’s color attachment point.
        var colorRenderbuffer: GLuint = 0
        glGenRenderbuffers(1, &colorRenderbuffer)
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), colorRenderbuffer)
        glRenderbufferStorage(GLenum(GL_RENDERBUFFER), GLenum(GL_RGBA8), width, height)
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), colorRenderbuffer)
        // Create a depth or depth/stencil renderbuffer, allocate storage for it, and attach it to the framebuffer’s depth attachment point.
        var depthRenderbuffer: GLuint = 0
        glGenRenderbuffers(1, &depthRenderbuffer)
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), depthRenderbuffer)
        glRenderbufferStorage(GLenum(GL_RENDERBUFFER), GLenum(GL_DEPTH_COMPONENT16), width, height)
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_DEPTH_ATTACHMENT), GLenum(GL_RENDERBUFFER), depthRenderbuffer)
        // Test the framebuffer for completeness. This test only needs to be performed when the framebuffer’s configuration changes.
        let status = glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER))
        if status != GLenum(GL_FRAMEBUFFER_COMPLETE) {
            NSLog("failed to make complete framebuffer object %x", status)
        }
        
        // create the texture
        var texture: GLuint = 0
        glGenTextures(1, &texture);
        glBindTexture(GLenum(GL_TEXTURE_2D), texture);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR);
        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA8,  width, height, 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), nil);
        glFramebufferTexture2D(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_TEXTURE_2D), texture, 0);
    }
}