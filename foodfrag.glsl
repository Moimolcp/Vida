#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D ftexture; // Data sent from Sketch by function texture()

varying vec4 vertColor;  // Passing data among shaders by function stroke() fill() [Interpolated]
varying vec4 vertTexCoord; // Passing data among shaders by function vertex() [Interpolated]

void main() {  
  gl_FragColor = texelFetch(ftexture, ivec2(vertTexCoord.xy),0);
  
}