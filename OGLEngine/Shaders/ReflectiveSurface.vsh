
attribute vec4 aPosition;
attribute vec2 aTexel;

uniform mat4 uModelViewProjectionMatrix;

varying lowp vec2 vTexel;
varying lowp vec4 vClipSpace;

void main() {
    vTexel = aTexel;
    vec4 position = uModelViewProjectionMatrix * aPosition;
    vClipSpace = position;
    gl_Position = position;
}