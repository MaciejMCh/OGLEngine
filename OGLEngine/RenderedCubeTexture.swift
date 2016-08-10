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
    private(set) var sideTextures: [CubeSideTexture] = []
    
    let w = GLsizei(512)
    let h = GLsizei(512)
    
    func bindFrameBuffers() {
        glBindTexture(GLenum(GL_TEXTURE_CUBE_MAP), self.glName);
        glTexParameteri(GLenum(GL_TEXTURE_CUBE_MAP), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE);
        glTexParameteri(GLenum(GL_TEXTURE_CUBE_MAP), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE);
        glTexParameteri(GLenum(GL_TEXTURE_CUBE_MAP), GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST);
        glTexParameteri(GLenum(GL_TEXTURE_CUBE_MAP), GLenum(GL_TEXTURE_MAG_FILTER), GL_NEAREST);

        glGenFramebuffers(6, &sideFrameBuffers[0]);
        
        for side in CubeTextureSide.allSidesInOrder() {
            glTexImage2D(side.glEnum(), 0, GL_RGBA, w, h, 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), nil);
        }
        for side in CubeTextureSide.allSidesInOrder() {
            bind(&sideFrameBuffers[side.cubeContextIndex()], textureSide: side)
        }
    }
    
    func withFbo(textureSide textureSide: CubeTextureSide, operations: ()->()) {
        var currentVboGlName = GLint()
        glGetIntegerv(GLenum(GL_FRAMEBUFFER_BINDING_OES), &currentVboGlName)
        
        bindFrameBuffer(sideFrameBuffers[textureSide.cubeContextIndex()])
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
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffer.memory);
        
        let buffs: [GLenum] = [GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_COLOR_ATTACHMENT1)]
        glDrawBuffers(2, buffs)
        
        glBindTexture(GLenum(GL_TEXTURE_CUBE_MAP), self.glName);
        glFramebufferTexture2D(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), textureSide.glEnum(), self.glName, 0);
        
        var sideTextureGlName = GLuint()
        glGenTextures(1, &sideTextureGlName)
        glBindTexture(GLenum(GL_TEXTURE_2D), sideTextureGlName);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_NEAREST);
        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, w, h, 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), nil);
        glFramebufferTexture2D(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT1), GLenum(GL_TEXTURE_2D), sideTextureGlName, 0)
        self.sideTextures.append(CubeSideTexture(glName: sideTextureGlName, side: textureSide))
        
        var depthbuffer: GLuint = 0;
        glGenRenderbuffers(1, &depthbuffer);
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), depthbuffer);
        glRenderbufferStorage(GLenum(GL_RENDERBUFFER), GLenum(GL_DEPTH_COMPONENT16), w, h);
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_DEPTH_ATTACHMENT), GLenum(GL_RENDERBUFFER), depthbuffer);
        let status = glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER));
        if(status != GLenum(GL_FRAMEBUFFER_COMPLETE)) {
            NSLog("Framebuffer \(textureSide) status: \(status)");
        }
    }
}

struct CubeSideTexture: Texture {
    let glName: GLuint
    let side: CubeTextureSide
    func bind() {
        
    }
}