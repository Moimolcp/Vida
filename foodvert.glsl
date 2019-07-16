uniform mat4 transform;

attribute vec4 position; // Data Sent by Sketch funciton Vertex() with vec4 type
attribute vec2 texCoord; // Data Sent by Sketch funciton Vertex()


varying vec4 vertTexCoord; // Passing data among shaders by function vertex()

void main() {
  gl_Position = transform * position;
  // Bluish to image
  // vertColor = vec4(0, 0, 1, 1);
  vertTexCoord = vec4(texCoord, 1.0, 1.0);
}