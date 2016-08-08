//
//  RenderedCubeTexture.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 08.08.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import GLKit

class RenderedCubeTexture: CubeTexture {
    
    private var sideFrameBuffers = Array<GLuint>(count: 6, repeatedValue: 0)
    
    let w = GLsizei(512)
    let h = GLsizei(512)
    
    func bindFrameBuffers() {
        bind(&sideFrameBuffers[0], textureSide: .NegativeX)
        bind(&sideFrameBuffers[1], textureSide: .PositiveX)
        bind(&sideFrameBuffers[2], textureSide: .NegativeY)
        bind(&sideFrameBuffers[3], textureSide: .PositiveY)
        bind(&sideFrameBuffers[4], textureSide: .NegativeZ)
        bind(&sideFrameBuffers[5], textureSide: .PositiveZ)
    }
    
    func withFbo(textureSide textureSide: CubeTextureSide, operations: ()->()) {
        var currentVboGlName = GLint()
        glGetIntegerv(GLenum(GL_FRAMEBUFFER_BINDING_OES), &currentVboGlName)
        
        switch textureSide {
        case .NegativeX: bindFrameBuffer(sideFrameBuffers[0])
        case .PositiveX: bindFrameBuffer(sideFrameBuffers[1])
        case .NegativeY: bindFrameBuffer(sideFrameBuffers[2])
        case .PositiveY: bindFrameBuffer(sideFrameBuffers[3])
        case .NegativeZ: bindFrameBuffer(sideFrameBuffers[4])
        case .PositiveZ: bindFrameBuffer(sideFrameBuffers[5])
        }
        operations()
        
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), GLuint(currentVboGlName))
        let scale = UIScreen.mainScreen().scale
        glViewport(0, 0, GLsizei(CGRectGetWidth(UIScreen.mainScreen().bounds) * scale), GLsizei(CGRectGetHeight(UIScreen.mainScreen().bounds) * scale))
    }
    
    func bindFrameBuffer(frameBufferGlName: GLuint, width: Int = 512, height: Int = 512) {
        glBindTexture(GLenum(GL_TEXTURE_2D), 0)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBufferGlName)
        glViewport(0, 0, GLsizei(width), GLsizei(height))
    }
    
    func bind(frameBuffer: UnsafeMutablePointer<GLuint>, textureSide: CubeTextureSide) {
        glGenFramebuffers(1, frameBuffer);
        
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffer.memory);
        glFramebufferTexture2D(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), textureSide.glEnum(), self.glName, 0);
        
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
