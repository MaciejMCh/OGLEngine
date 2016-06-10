//
//  PipelineProgramDefaultImplementations.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 30.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

extension PipelineProgram where RenderableType: Mesh {
    
    func draw(mesh: Mesh) {
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(mesh.vao.vertexCount), GLenum(GL_UNSIGNED_INT), nil);
    }
    
    func bindAttributes(mesh: Mesh) {
        glBindVertexArrayOES(mesh.vao.vaoGLName)
        for attribute in self.pipeline.vertexShader.attributes.collection {
            glEnableVertexAttribArray(attribute.location)
        }
    }
    
    func unbindAttributes(mesh: Mesh) {
        for attribute in self.pipeline.vertexShader.attributes.collection {
            glDisableVertexAttribArray(attribute.location)
        }
        glBindVertexArrayOES(0);
    }
    
}

extension Model {
    func modelViewProjectionMatrix(camera: Camera) -> GLKMatrix4 {
        let modelMatrix = self.geometryModel.modelMatrix()
        let viewProjectionMatrix = camera.viewProjectionMatrix()
        let modelViewProjectionMatrix = modelMatrix * viewProjectionMatrix
        return modelViewProjectionMatrix
    }
    
    func normalMatrix() -> GLKMatrix3 {
        return invertAndTransposeMatrix(self.geometryModel.modelMatrix())
    }
}

extension PipelineProgram where RenderableType: Model {
    
    func passModelMatrix(model: Model) {
        var modelMatrix = model.geometryModel.modelMatrix()
        withUnsafePointer(&modelMatrix, {
            glUniformMatrix4fv(self.pipeline.uniform(GPUUniforms.modelMatrix).location, 1, 0, UnsafePointer($0))
        })
    }
    
    func passNormalMatrix(model: Model) {
        var normalMatrix = invertAndTransposeMatrix(model.geometryModel.modelMatrix())
        withUnsafePointer(&normalMatrix, {
            glUniformMatrix3fv(self.pipeline.uniform(GPUUniforms.normalMatrix).location, 1, 0, UnsafePointer($0))
        })
    }
    
    func passViewProjectionMatrix(camera: Camera) {
        var viewProjectionMatrix = camera.viewProjectionMatrix()
        withUnsafePointer(&viewProjectionMatrix, {
            glUniformMatrix4fv(self.pipeline.uniform(GPUUniforms.viewProjectionMatrix).location, 1, 0, UnsafePointer($0))
        })
    }
    
    func passModelViewProjectionMatrix(model: Model, camera: Camera) {
        let modelMatrix = model.geometryModel.modelMatrix()
        let viewProjectionMatrix = camera.viewProjectionMatrix()
        
        var modelViewProjectionMatrix = modelMatrix * viewProjectionMatrix
        
        withUnsafePointer(&modelViewProjectionMatrix, {
            glUniformMatrix4fv(self.pipeline.uniform(GPUUniforms.modelViewProjectionMatrix).location, 1, 0, UnsafePointer($0))
        })
    }
    
    func passLightHalfVector(model: Model, camera: Camera, light: DirectionalLight) {
        let visibleReflectionContext = VisibleReflectionContext(model: model.geometryModel, camera: camera, light: light)
        var halfVector = visibleReflectionContext.halfVector()
        withUnsafePointer(&halfVector, {
            glUniform3fv(self.pipeline.uniform(GPUUniforms.lightHalfVector).location, 1, UnsafePointer($0))
        })
    }
    
}