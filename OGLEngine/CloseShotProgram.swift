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
    typealias RenderableType = FinalRenderable
    var shaderName: String = "Shader"
    var interface: GPUInterface = DefaultInterfaces.detailInterface()
    var glName: GLuint  = 0
    
    var camera: Camera!
    var directionalLight: DirectionalLight!
    var normalMap: Texture!
    
    required init() {
        
    }
    
    func render(renderables: [FinalRenderable]) {
        var eyePosition = camera.cameraPosition()
        eyePosition = GLKVector3MultiplyScalar(eyePosition, -1)
        withUnsafePointer(&eyePosition, {
            glUniform3fv(self.interface.uniforms.uniformNamed(.eyePosition).location, 1, UnsafePointer($0))
        })
        
        var directionalLightDirection: GLKVector3 = directionalLight.direction()
        withUnsafePointer(&directionalLightDirection, {
            glUniform3fv(self.interface.uniforms.uniformNamed(.lightDirection).location, 1, UnsafePointer($0))
        })
        
        for renderable in renderables {
            self.bind(renderable)
            self.bindTexture(renderable)
            self.passMatrices(renderable, camera: camera)
            self.draw(renderable)
            self.unbind(renderable)
        }
        
    }
    
    func bind(mesh: Mesh) {
        glBindVertexArrayOES(mesh.vao.vaoGLName)
        for attribute in self.interface.attributes {
            glEnableVertexAttribArray(attribute.location)
        }
    }
    
    func unbind(mesh: Mesh) {
        for attribute in self.interface.attributes {
            glDisableVertexAttribArray(attribute.location)
        }
        glBindVertexArrayOES(0);
    }
    
    func bindTexture(bumpMapped: BumpMapped) {
        glActiveTexture(GLenum(GL_TEXTURE0));
        glBindTexture(GLenum(GL_TEXTURE_2D), bumpMapped.colorMap.glName)
        glActiveTexture(GLenum(GL_TEXTURE1));
        glBindTexture(GLenum(GL_TEXTURE_2D), bumpMapped.normalMap.glName);
        glUniform1i(self.interface.uniforms.uniformNamed(.colorMap).location, 0);
        glUniform1i(self.interface.uniforms.uniformNamed(.normalMap).location, 1);
    }
    
    func passMatrices(model: Model, camera: Camera) {
        var modelMatrix = model.geometryModel.modelMatrix()
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
        
        var normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(model.geometryModel.modelMatrix()), nil);
        withUnsafePointer(&normalMatrix, {
            glUniformMatrix3fv(self.interface.uniforms.uniformNamed(.normalMatrix).location, 1, 0, UnsafePointer($0))
        })
        
    }
    
    func draw(mesh: Mesh) {
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(mesh.vao.vertexCount), GLenum(GL_UNSIGNED_INT), nil);
    }
    
}
