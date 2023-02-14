shader_type spatial; 
render_mode unshaded;

// These are the Uniforms I have, yours may differ
// Names must match what exists in your Shader Globals
global uniform vec4 EnvFogColor;
global uniform float EnvFogStart;
global uniform float EnvFogEnd;
global uniform vec4 EnvLightColor;
global uniform vec3 EnvLightDir;

uniform sampler2D _texture : source_color, filter_nearest; // Forces point sampling for now
uniform vec2 uv_scale = vec2(0.5, 0.5);

varying float vfog;

void vertex() {
	// World-space UVs
	vec3 p = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	UV = p.xz * uv_scale;
	
	// Vertex Fog, using View Z-depth
	vec4 V = PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(VERTEX, 1.0);
	float z = V.z;
	z = max(0.0, z-EnvFogStart);
	vfog = clamp(z / (EnvFogEnd - EnvFogStart), 0.0, 1.0);
	
	// Vertex Lighting, simple
	vec3 N = (MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz;
	N = normalize(N); // Must normalize b/c of potential Scaling
	float ndl =  max(0.0, dot(N, EnvLightDir));
	COLOR.rgb = EnvFogColor.rgb + (EnvLightColor.rgb * ndl);
}

void fragment() {
	// Texture & Vertex Lighting
	vec4 tex = texture(_texture, UV);
	ALBEDO = tex.rgb * COLOR.rgb;
	
	// Blend over the Vertex Fog
	FOG.rgb = EnvFogColor.rgb;
	FOG.a = vfog;
}
