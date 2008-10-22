varying vec3		vEyeVector;
varying vec3		vNormal;


void main(void)
{
	vEyeVector = vec3(gl_ModelViewMatrix * gl_Vertex);
	vNormal = normalize(gl_NormalMatrix * gl_Normal);
	
	gl_Position = ftransform();
}
