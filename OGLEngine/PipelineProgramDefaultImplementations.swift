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
        return trimToMat3(self.geometryModel.modelMatrix())
    }
    
    func tangentNormalMatrix() -> GLKMatrix3 {
        let normalMatrix = self.normalMatrix()
        let transposedNormalMatrix = transpose(normalMatrix)
        return transposedNormalMatrix
    }
}

extension PipelineProgram {
    func defaultSceneBindings(scene: Scene) {
        if let eyePosition = self.pipeline.uniform(GPUUniforms.eyePosition) {
            eyePosition.cpuVariableGetter = {scene.camera.cameraPosition()}
        }
        if let lightVersor = self.pipeline.uniform(GPUUniforms.lightVersor) {
            lightVersor.cpuVariableGetter = {scene.directionalLight.lightVersor()}
        }
        if let lightColor = self.pipeline.uniform(GPUUniforms.lightColor) {
            lightColor.cpuVariableGetter = {(r: 1.0, g: 1.0, b:1.0, a:1.0)}
        }
        if let shininess = self.pipeline.uniform(GPUUniforms.shininess) {
            shininess.cpuVariableGetter = {100.0}
        }
        if let lightHalfVector = self.pipeline.uniform(GPUUniforms.lightHalfVector) {
            lightHalfVector.cpuVariableGetter = {scene.directionalLight.halfVectorWithCamera(scene.camera)}
        }
    }
    
    func defaultModelBindings(model: Model, scene: Scene) {
        if let modelMatrix = self.pipeline.uniform(GPUUniforms.modelMatrix) {
            modelMatrix.cpuVariableGetter = {model.geometryModel.modelMatrix()}
        }
        if let viewProjectionMatrix = self.pipeline.uniform(GPUUniforms.viewProjectionMatrix) {
            viewProjectionMatrix.cpuVariableGetter = {scene.camera.viewProjectionMatrix()}
        }
        if let modelViewProjectionMatrix = self.pipeline.uniform(GPUUniforms.modelViewProjectionMatrix) {
            modelViewProjectionMatrix.cpuVariableGetter = {model.modelViewProjectionMatrix(scene.camera)}
        }
        if let normalMatrix = self.pipeline.uniform(GPUUniforms.normalMatrix) {
            normalMatrix.cpuVariableGetter = {model.normalMatrix()}
        }
    }
    
    func defaultColorMappedBindings(colorMapped: ColorMapped) {
        if let colorMap = self.pipeline.uniform(GPUUniforms.colorMap) {
            colorMap.cpuVariableGetter = {(colorMapped.colorMap, 0)}
        }
    }
    
    func defaultNormalMappedBindings(normalMapped: NormalMapped) {
        if let normalMap = self.pipeline.uniform(GPUUniforms.normalMap) {
            normalMap.cpuVariableGetter = {(normalMapped.normalMap, 1)}
        }
    }
    
    func defaultSpecularMappedBindings(specularMapped: SpecularMapped) {
        if let specularMap = self.pipeline.uniform(GPUUniforms.specularMap) {
            specularMap.cpuVariableGetter = {(specularMapped.specularMap, 2)}
        }
    }
    
    func defaultReflectiveSurfaceBindings(reflectiveSurface: ReflectiveSurface) {
        if let reflectionColorMap = self.pipeline.uniform(GPUUniforms.reflectionColorMap) {
            reflectionColorMap.cpuVariableGetter = {(reflectiveSurface.reflectionColorMap, 0)}
        }
    }
}
