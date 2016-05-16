//
//  RenderedTexture.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 16.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

struct RenderedTexture {
    
    var frameBufferGlName: GLuint = 0
    var depthBufferGlName: GLuint = 0
    var textureGlName: GLuint = 0
    
    init() {
        var t = GLuint()
        var f = GLuint()
        generateTextureFromFramebuffer(&t, f: &f, w: 512, h: 512)
        frameBufferGlName = f
        textureGlName = t
    }
    
    func unbindCurrentFrameBuffer() {
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), 1)
        let scale = UIScreen.mainScreen().scale
        glViewport(0, 0, GLsizei(CGRectGetWidth(UIScreen.mainScreen().bounds) * scale), GLsizei(CGRectGetHeight(UIScreen.mainScreen().bounds) * scale))
    }
    
    func bindFrameBuffer(frameBufferGlName: GLuint, width: Int = 512, height: Int = 512) {
        glBindTexture(GLenum(GL_TEXTURE_2D), 0)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBufferGlName)
        glViewport(0, 0, GLsizei(width), GLsizei(height))
    }
    
    func bind() {
        bindFrameBuffer(frameBufferGlName, width: 512, height: 512)
    }
    
    func generateTextureFromFramebuffer(t: UnsafeMutablePointer<GLuint>, f: UnsafeMutablePointer<GLuint>, w: GLsizei, h: GLsizei) {
        glGenFramebuffers(1, f);
        glGenTextures(1, t);
        
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), f.memory);
        
        glBindTexture(GLenum(GL_TEXTURE_2D), t.memory);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_NEAREST);
        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, w, h, 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), nil);
        glFramebufferTexture2D(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_TEXTURE_2D), t.memory, 0);
        
        var depthbuffer: GLuint = 0;
        glGenRenderbuffers(1, &depthbuffer);
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), depthbuffer);
        glRenderbufferStorage(GLenum(GL_RENDERBUFFER), GLenum(GL_DEPTH_COMPONENT16), w, h);
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_DEPTH_ATTACHMENT), GLenum(GL_RENDERBUFFER), depthbuffer);
        
        let status = glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER));
        if(status != GLenum(GL_FRAMEBUFFER_COMPLETE)) {
            NSLog("Framebuffer status: %x", Int(status));
        }
    }

    
}