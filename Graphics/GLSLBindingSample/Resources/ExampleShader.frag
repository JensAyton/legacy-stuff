// These are bound to model properties; see -[ExampleOpenGLView setUp].
uniform vec4		uColor;
uniform float		uShininess;	// Range: 0..8

varying vec3		vEyeVector;
varying vec3		vNormal;


#define LIGHT(n)	{ \
	vec3 lightVector = normalize(gl_LightSource[n].position.xyz); \
	vec3 reflection = normalize(-reflect(lightVector, normal)); \
	float diffuseIntensity = max(dot(normal, lightVector), 0.0); \
	float specularIntensity = uShininess / 10.0 * pow(max(dot(reflection, eyeVector), 0.0), exp2(uShininess)); \
	vec4 diffuseColor = uColor * gl_LightSource[n].diffuse * diffuseIntensity; \
	vec4 specularColor = gl_LightSource[n].diffuse * specularIntensity; \
	color += diffuseColor + specularColor; \
}


void main(void)
{
	vec4 color = uColor * gl_LightModel.ambient;
	
	vec3 eyeVector = normalize(vEyeVector);
	vec3 normal = normalize(vNormal);
	
	LIGHT(0);
	LIGHT(1);
	
	gl_FragColor = color;
}
