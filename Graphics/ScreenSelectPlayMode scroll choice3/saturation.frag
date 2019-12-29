#version 120

varying vec2 textureCoord;
uniform sampler2D sampler0;

uniform float saturation;

void main(void) {
	vec4 sample =  texture2D(sampler0, textureCoord);
	float grey = 0.21 * sample.r + 0.71 * sample.g + 0.07 * sample.b;
	gl_FragColor = vec4(sample.rgb * saturation + grey * (1-saturation), sample.a);
}