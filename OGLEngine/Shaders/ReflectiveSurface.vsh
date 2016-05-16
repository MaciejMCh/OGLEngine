
attribute vec4 aPosition;
attribute vec2 aTexel;

uniform mat4 uModelViewProjectionMatrix;

varying lowp vec2 vTexel;

void main() {
    vTexel = aTexel;
    vec4 position = uModelViewProjectionMatrix * aPosition;
    gl_Position = position;
}