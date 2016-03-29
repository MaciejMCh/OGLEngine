//
//  CloseShotProgram.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 29.03.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class CloseShotProgram: GPUProgram {
    
    var shaderName: String = ""
    var interface: GPUInterface = DefaultInterfaces.none() {
        didSet (ads) {
            
        }
        willSet (asd) {
            
        }
    }
    var glName: GLuint  = 0
    
    var camera: Camera!
    var directionalLight: DirectionalLight!
    var normalMap: Texture!
    
    static func instantiate() -> GPUProgram {
        return self.init(shaderName: "Shader", interface: DefaultInterfaces.detailInterface())
    }
    
    required init() {
        
    }
    
    func render(renderables: [Renderable]) {
        var eyePosition = camera.cameraPosition()
        eyePosition = GLKVector3MultiplyScalar(eyePosition, -1)
        withUnsafePointer(&eyePosition, {
            glUniform3fv(self.interface.uniforms.uniformNamed(.eyePosition).location, 1, UnsafePointer($0))
        })
        
        var directionalLightDirection: GLKVector3 = directionalLight.direction()
        withUnsafePointer(&directionalLightDirection, {
            glUniform3fv(self.interface.uniforms.uniformNamed(.lightDirection).location, 1, UnsafePointer($0))
        })
        
        NSLog("render")
        for uniform in self.interface.uniforms {
            NSLog("%@ %d", uniform.gpuDomainName(), uniform.location)
        }
        
        for renderable in renderables {
            self.bind(renderable)
            self.bindTexture(renderable, normalMap: normalMap)
            self.passMatrices(renderable, camera: camera)
            self.draw(renderable)
            self.unbind(renderable)
        }
        
    }
    
    func bind(renderable: Renderable) {
        glBindVertexArrayOES(renderable.vao.vaoGLName)
        glEnableVertexAttribArray(GLuint(VboIndex.Positions.rawValue))
        glEnableVertexAttribArray(GLuint(VboIndex.Texels.rawValue))
        glEnableVertexAttribArray(GLuint(VboIndex.Normals.rawValue))
        glEnableVertexAttribArray(GLuint(VboIndex.Tangents.rawValue))
        glEnableVertexAttribArray(GLuint(VboIndex.Bitangents.rawValue))
    }
    
    func unbind(renderable: Renderable) {
        glDisableVertexAttribArray(GLuint(VboIndex.Positions.rawValue))
        glDisableVertexAttribArray(GLuint(VboIndex.Texels.rawValue))
        glDisableVertexAttribArray(GLuint(VboIndex.Normals.rawValue))
        glDisableVertexAttribArray(GLuint(VboIndex.Tangents.rawValue))
        glDisableVertexAttribArray(GLuint(VboIndex.Bitangents.rawValue))
        
        glBindVertexArrayOES(0);
    }
    
    func bindTexture(renderable: Renderable, normalMap: Texture) {
        glActiveTexture(GLenum(GL_TEXTURE0));
        glBindTexture(GLenum(GL_TEXTURE_2D), renderable.texture.glName)
        glActiveTexture(GLenum(GL_TEXTURE1));
        glBindTexture(GLenum(GL_TEXTURE_2D), normalMap.glName);
        glUniform1i(self.interface.uniforms.uniformNamed(.colorMap).location, 0);
        glUniform1i(self.interface.uniforms.uniformNamed(.normalMap).location, 1);
    }
    
    func passMatrices(renderable: Renderable, camera: Camera) {
        var modelMatrix = renderable.geometryModel.modelMatrix()
        var viewMatrix = camera.viewMatrix()
        var projectionMatrix = camera.projectionMatrix()
        
        withUnsafePointer(&modelMatrix, {
            glUniformMatrix4fv(self.interface.uniforms.uniformNamed(.modelMatrix).location, 1, 0, UnsafePointer($0))
        })
        withUnsafePointer(&viewMatrix, {
            glUniformMatrix4fv(self.interface.uniforms.uniformNamed(.viewMatrix).location, 1, 0, UnsafePointer($0))
        })
        withUnsafePointer(&projectionMatrix, {
            glUniformMatrix4fv(self.interface.uniforms.uniformNamed(.projectionMatrix).location, 1, 0, UnsafePointer($0))
        })
        
        var normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(renderable.geometryModel.modelMatrix()), nil);
        withUnsafePointer(&normalMatrix, {
            glUniformMatrix3fv(self.interface.uniforms.uniformNamed(.normalMatrix).location, 1, 0, UnsafePointer($0))
        })
        
    }
    
    func draw(renderable: Renderable) {
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(renderable.vao.vertexCount), GLenum(GL_UNSIGNED_INT), nil);
    }
    
}