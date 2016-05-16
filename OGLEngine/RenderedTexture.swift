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
        
        glGenTextureFromFramebuffer(&t, f: &f, w: 512, h: 512)
        
        frameBufferGlName = f
        textureGlName = t
        
//        frameBufferGlName = createFrameBuffer()
//        textureGlName = createTextureAttachment()
//        depthBufferGlName = createDepthBufferAttachment()
    }
    
    func createFrameBuffer() -> GLuint {
        var glName: GLuint = 0
        glGenFramebuffers(1, &glName)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), glName)
        glDrawBuffers(1, [GLenum(GL_COLOR_ATTACHMENT0)])
        return glName
    }
    
    func createTextureAttachment(width: Int = 512, height: Int = 512) -> GLuint {
        var textureGlName: GLuint = 0
        glGenTextures(1, &textureGlName)
        glBindTexture(GLenum(GL_TEXTURE_2D), textureGlName)
        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGB, GLsizei(width), GLsizei(height), 0, GLenum(GL_RGB), GLenum(GL_UNSIGNED_BYTE), nil)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR)
        glFramebufferTexture2D(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_TEXTURE_2D), textureGlName, 0)
        return textureGlName
    }
    
//    private void initialiseReflectionFrameBuffer() {
    static func initialiseReflectionFrameBuffer() -> RenderedTexture {
        let buffer = RenderedTexture()
//    reflectionFrameBuffer = createFrameBuffer();
//    reflectionTexture = createTextureAttachment(REFLECTION_WIDTH,REFLECTION_HEIGHT);
//    reflectionDepthBuffer = createDepthBufferAttachment(REFLECTION_WIDTH,REFLECTION_HEIGHT);
//    unbindCurrentFrameBuffer();
        buffer.unbindCurrentFrameBuffer()
        return buffer
    }
    
    func createDepthTextureAttachment(width: Int = 512, height: Int = 512) -> GLuint {
//    int texture = GL11.glGenTextures();
        var textureGlName: GLuint = 0
        glGenTextures(1, &textureGlName)
//    GL11.glBindTexture(GL11.GL_TEXTURE_2D, texture);
        glBindTexture(GLenum(GL_TEXTURE_2D), textureGlName)
//    GL11.glTexImage2D(GL11.GL_TEXTURE_2D, 0, GL14.GL_DEPTH_COMPONENT32, width, height,
//    0, GL11.GL_DEPTH_COMPONENT, GL11.GL_FLOAT, (ByteBuffer) null);
        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_DEPTH_COMPONENT32F, GLsizei(width), GLsizei(height), 0, GLenum(GL_DEPTH_COMPONENT), GLenum(GL_FLAT), nil)
//    GL11.glTexParameteri(GL11.GL_TEXTURE_2D, GL11.GL_TEXTURE_MAG_FILTER, GL11.GL_LINEAR);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)
//    GL11.glTexParameteri(GL11.GL_TEXTURE_2D, GL11.GL_TEXTURE_MIN_FILTER, GL11.GL_LINEAR);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR)
//    GL32.glFramebufferTexture(GL30.GL_FRAMEBUFFER, GL30.GL_DEPTH_ATTACHMENT,
//    texture, 0);
        glFramebufferTexture2D(GLenum(GL_FRAMEBUFFER), GLenum(GL_DEPTH_ATTACHMENT), GLenum(GL_TEXTURE_2D), textureGlName, 0)
//    return texture;
        return textureGlName
    }
    
//    private int createDepthBufferAttachment(int width, int height) {
    func createDepthBufferAttachment(width: Int = 512, height: Int = 512) -> GLuint {
//    int depthBuffer = GL30.glGenRenderbuffers();
        var bufferGlName: GLuint = 0
        glGenRenderbuffers(1, &bufferGlName)
//    GL30.glBindRenderbuffer(GL30.GL_RENDERBUFFER, depthBuffer);
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), bufferGlName)
//    GL30.glRenderbufferStorage(GL30.GL_RENDERBUFFER, GL11.GL_DEPTH_COMPONENT, width,
//    height);
        glRenderbufferStorage(GLenum(GL_RENDERBUFFER), GLenum(GL_DEPTH_COMPONENT), GLsizei(width), GLsizei(height))
//    GL30.glFramebufferRenderbuffer(GL30.GL_FRAMEBUFFER, GL30.GL_DEPTH_ATTACHMENT,
//    GL30.GL_RENDERBUFFER, depthBuffer);
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_DEPTH_ATTACHMENT), GLenum(GL_RENDERBUFFER), bufferGlName)
//    return depthBuffer;
        return bufferGlName
    }
    
//    public void unbindCurrentFrameBuffer() {//call to switch to default frame buffer
    func unbindCurrentFrameBuffer() {
//    GL30.glBindFramebuffer(GL30.GL_FRAMEBUFFER, 0);
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), 1)
//    GL11.glViewport(0, 0, Display.getWidth(), Display.getHeight());
        let scale = UIScreen.mainScreen().scale
        glViewport(0, 0, GLsizei(CGRectGetWidth(UIScreen.mainScreen().bounds) * scale), GLsizei(CGRectGetHeight(UIScreen.mainScreen().bounds) * scale))
    }
    
//    private void bindFrameBuffer(int frameBuffer, int width, int height){
    func bindFrameBuffer(frameBufferGlName: GLuint, width: Int = 512, height: Int = 512) {
//    GL11.glBindTexture(GL11.GL_TEXTURE_2D, 0);//To make sure the texture isn't bound
        glBindTexture(GLenum(GL_TEXTURE_2D), 0)
//    GL30.glBindFramebuffer(GL30.GL_FRAMEBUFFER, frameBuffer);
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBufferGlName)
//    GL11.glViewport(0, 0, width, height);
        glViewport(0, 0, GLsizei(width), GLsizei(height))
    }
    
    func bind() {
        bindFrameBuffer(frameBufferGlName, width: 512, height: 512)
    }
    
}