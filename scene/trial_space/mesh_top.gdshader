shader_type spatial;

uniform float speed : hint_range(0.1, 100.0) = 1.0;
uniform float frequency: hint_range(0.01, 100.0)=1.0;
uniform vec4 strip_color : source_color;

void fragment() {
	vec3 world_normal = (INV_VIEW_MATRIX*vec4(NORMAL,0.0)).xyz;
	vec3 model_normal = inverse(mat3(MODEL_MATRIX))*world_normal;
	float k = dot(model_normal,vec3(0.0,1.0,0.0));
	vec2 uv = UV;
	vec2 p = uv * frequency;
	float time = TIME * speed;
	
	float r = sin(p.x + p.y + time) * 0.5 + 0.5;
	ALBEDO = strip_color.rgb;
	
	if ((r>0.5)||(k<0.9)) {
		ALPHA = 0.0;
	}
	
}

