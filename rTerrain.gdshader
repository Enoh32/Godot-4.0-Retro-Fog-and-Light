shader_type spatial; 
render_mode unshaded;

global uniform vec4 EnvFogColor;
global uniform float EnvFogStart;
global uniform float EnvFogEnd;
global uniform vec4 EnvLightColor;
global uniform vec3 EnvLightDir;

uniform sampler2D _texture : source_color, filter_nearest;
uniform vec2 uv_scale = vec2(0.5, 0.5);

varying float vfog;

void vertex() {
	// UVs
	vec3 p = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	UV = p.xz * uv_scale;
	
	// Vertex Fog
	vec4 V = PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(VERTEX, 1.0);
	float z = V.z;
	z -= EnvFogStart;
	vfog = clamp(z / (EnvFogEnd - EnvFogStart), 0.0, 1.0);
	
	// Vertex Light
	vec3 N = (MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz;
	N = normalize(N);
	float ndl =  max(0.0, dot(N, EnvLightDir));
	COLOR.rgb = EnvFogColor.rgb + (EnvLightColor.rgb * ndl);
}

void fragment() {
	// Texture & Vertex Lighting
	vec4 tex = texture(_texture, UV);
	ALBEDO = tex.rgb * COLOR.rgb;
	
	// Vertex Fog
	FOG.rgb = EnvFogColor.rgb;
	FOG.a = vfog;
}