// ==============================================================================
// SINGLE SOURCE OF TRUTH: 3D Force Field / Shield Spatial Shader (Godot 4.x)
// ==============================================================================
// Usage:
// 1. Create a MeshInstance3D (e.g. SphereMesh).
// 2. Assign a ShaderMaterial to it.
// 3. Set this shader inside that material.
// 4. Set blend_mode to Blend Mode Add or Mix.
// ==============================================================================
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx, unshaded;

uniform vec4 shield_color : source_color = vec4(0.0, 0.6, 1.0, 0.4);
uniform float fresnel_power : hint_range(0.1, 10.0) = 3.0;
uniform float edge_intensity : hint_range(0.1, 5.0) = 2.0;
uniform float ripple_speed : hint_range(0.1, 5.0) = 1.0;
uniform float ripple_frequency : hint_range(1.0, 50.0) = 10.0;
uniform float ripple_amplitude : hint_range(0.0, 0.5) = 0.05;

void fragment() {
	// 1. Calculate Fresnel Effect (makes edges glow brighter based on camera view)
	float fresnel = 1.0 - dot(normalize(NORMAL), normalize(VIEW));
	fresnel = pow(fresnel, fresnel_power) * edge_intensity;
	
	// 2. Calculate animated wave ripples
	float wave = sin(UV.y * ripple_frequency - TIME * ripple_speed) * ripple_amplitude;
	
	// 3. Combine color, fresnel glow and ripples
	vec3 final_color = shield_color.rgb + (fresnel * shield_color.rgb);
	float final_alpha = clamp(shield_color.a + fresnel + wave, 0.0, 1.0);
	
	ALBEDO = final_color;
	ALPHA = final_alpha;
}
