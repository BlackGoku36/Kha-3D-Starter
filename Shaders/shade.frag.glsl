#version 450

out vec4 fragColor;

in vec3 normal;
in vec3 fragPos;

uniform vec3 objectAlbedo;
uniform float objectAO;

uniform vec3 lightPosition;
uniform vec3 lightColor;


void main(){
	
    vec3 N = normalize(normal);
    vec3 L = normalize(lightPosition-fragPos);
    float diff = max(dot(N, L), 0.0);
    vec3 diffuse = diff * lightColor;
    vec3 color = (objectAO + diffuse) * objectAlbedo;
   
    fragColor = vec4(color, 1.0);
}  
