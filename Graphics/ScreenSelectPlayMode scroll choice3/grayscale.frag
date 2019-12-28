#version 120
#define saturate(i) clamp(i,0.,1.)

varying vec2 textureCoord;
uniform sampler2D sampler0;

uniform float howGray;


void main(void) {
	vec4 sample =  texture2D(sampler0, textureCoord);
	float grey = 0.21 * sample.r + 0.71 * sample.g + 0.07 * sample.b;
	gl_FragColor = vec4(sample.rgb * (1.0 - howGray) + (grey * howGray), sample.a);
}