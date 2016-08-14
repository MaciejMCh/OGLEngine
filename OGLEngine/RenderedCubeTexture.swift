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
    var sideTextures: [CubeSideTexture] {
        get {
            if self.sideTextures.count == 0 {
                produceSidesTextures()
            }
            return self.sideTextures
        }
        set {
            sideTextures = newValue
        }
    }
    
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
    
    func produceSidesTextures() {
        for side in CubeTextureSide.allSidesInOrder() {
            // Create and bind texture
            var t = GLuint()
            glGenTextures(1, &t);
            glBindTexture(GLenum(GL_TEXTURE_2D), t);
            
            // Bind framebuffer
            let frameBuffer = sideFrameBuffers[side.cubeContextIndex()]
            glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffer);
            
            // Set framebuffer attachments
            let attachments: [GLenum] = [GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_COLOR_ATTACHMENT1)]
            glDrawBuffers(2, attachments)
            
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST)
            glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, w, h, 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), nil);
            glFramebufferTexture2D(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT1), GLenum(GL_TEXTURE_2D), t, 0);
            
            let status = glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER));
            if(status != GLenum(GL_FRAMEBUFFER_COMPLETE)) {
                NSLog("Framebuffer status: %x", Int(status));
            }
            self.sideTextures.append(CubeSideTexture(glName: t, side: side))
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
        glBindTexture(GLenum(GL_TEXTURE_CUBE_MAP), self.glName);
        glFramebufferTexture2D(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), textureSide.glEnum(), self.glName, 0);
        
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
    
    func blurringContextForSide(side: CubeTextureSide) -> CubeTextureBlurringContext {
        var topTexture = sideTextures.getSide(.NegativeY)
        var leftTexture = sideTextures.getSide(.NegativeY)
        var bottomTexture = sideTextures.getSide(.NegativeY)
        var rightTexture = sideTextures.getSide(.NegativeY)
        var transformations: (top: Int32, left: Int32, bottom: Int32, right: Int32) = (top: 0, left: 0, bottom: 0, right: 0)
        
        switch side {
        case .PositiveX:
            transformations = (top: 7, left: 6, bottom: 0, right: 5)
            topTexture = sideTextures.getSide(.NegativeY)
            bottomTexture = sideTextures.getSide(.PositiveY)
            rightTexture = sideTextures.getSide(.NegativeZ)
            leftTexture = sideTextures.getSide(.PositiveZ)
        case .NegativeX:
            transformations = (top: 5, left: 4, bottom: 0, right: 2)
            topTexture = sideTextures.getSide(.NegativeY)
            bottomTexture = sideTextures.getSide(.PositiveY)
            rightTexture = sideTextures.getSide(.PositiveZ)
            leftTexture = sideTextures.getSide(.NegativeZ)
        case .PositiveY:
            transformations = (top: 3, left: 1, bottom: 7, right: 4)
            topTexture = sideTextures.getSide(.PositiveZ)
            bottomTexture = sideTextures.getSide(.NegativeZ)
            rightTexture = sideTextures.getSide(.PositiveX)
            leftTexture = sideTextures.getSide(.NegativeX)
        case .NegativeY:
            transformations = (top: 0, left: 2, bottom: 5, right: 6)
            topTexture = sideTextures.getSide(.NegativeZ)
            bottomTexture = sideTextures.getSide(.PositiveZ)
            rightTexture = sideTextures.getSide(.PositiveX)
            leftTexture = sideTextures.getSide(.NegativeX)
        case .PositiveZ:
            transformations = (top: 0, left: 1, bottom: 0, right: 2)
            topTexture = sideTextures.getSide(.NegativeY)
            bottomTexture = sideTextures.getSide(.PositiveY)
            rightTexture = sideTextures.getSide(.PositiveX)
            leftTexture = sideTextures.getSide(.NegativeX)
        case .NegativeZ:
            transformations = (top: 3, left: 2, bottom: 0, right: 2)
            topTexture = sideTextures.getSide(.NegativeY)
            bottomTexture = sideTextures.getSide(.PositiveY)
            rightTexture = sideTextures.getSide(.NegativeX)
            leftTexture = sideTextures.getSide(.PositiveX)
        }
        return CubeTextureBlurringContext(
            transformations: transformations,
            blurringTexture: sideTextures.getSide(side),
            topTexture: topTexture,
            leftTexture: leftTexture,
            bottomTexture: bottomTexture,
            rightTexture: rightTexture)
    }
}

struct CubeSideTexture: Texture {
    let glName: GLuint
    let side: CubeTextureSide
    func bind() {
        
    }
}

extension CollectionType where Self.Generator.Element == CubeSideTexture {
    func getSide(side: CubeTextureSide) -> CubeSideTexture! {
        for element in self {
            if element.side == side {
                return element
            }
        }
        return nil
    }
}