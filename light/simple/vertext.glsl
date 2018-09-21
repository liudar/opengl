#version 300 es
uniform mat4 uMVPMatrix;
uniform mat4 uMMatrix;
uniform vec3 uCamera;
uniform vec3 uLightLocationSun;

in vec3 aPosition;
in vec3 aNormal;
in vec2 aTexCoor;

out vec2 vTexCoor;
out vec4 vAmbient;
out vec4 vDiffuse;
out vec4 vSpecular;

void pointLight(
    in vec3 normal,
    inout vec4 ambient,
    inout vec4 diffuse,
    inout vec4 specular,
    in vec3 uLightLocation,
    in vec4 lightAmbient,
    in vec4 lightDiffuse,
    in vec4 lightSpecular
){
    ambient = lightAmbient;
    vec3 normalTarget = aPosition + normal;
    vec3 newNormal = normalize((uMMatrix * vec4(normalTarget,1)).xyz - (uMMatrix * vec4(aPosition,1)).xyz);

    vec3 vp = normalize(uLightLocationSun - (uMMatrix * vec4(aPosition,1)).xyz);
    vec3 eye = normalize(uCamera - (uMMatrix * vec4(aPosition,1)).xyz);

    vec3 halfVector = normalize(vp + eye);

    float shin = 2.0;

    diffuse = lightDiffuse * max(0.0,dot(newNormal,vp));
    specular = lightSpecular * max(0.0,pow(dot(newNormal,halfVector),shin));
}

void main(){
    gl_Position = uMVPMatrix * vec4(aPosition,1);

     vec4 ambientTemp = vec4(0.0,0.0,0.0,0.0);
     vec4 diffuseTemp = vec4(0.0,0.0,0.0,0.0);
     vec4 specularTemp = vec4(0.0,0.0,0.0,0.0);
     pointLight(normalize(aNormal),ambientTemp,diffuseTemp,specularTemp,uLightLocationSun,vec4(0.05,0.05,0.05,1.0),vec4(0.5,0.5,0.5,1.0),vec4(1.0,1.0,1.0,1.0));
     vAmbient = ambientTemp;
     vDiffuse = diffuseTemp;
     vSpecular = specularTemp;
     vTexCoor = aTexCoor;
}
