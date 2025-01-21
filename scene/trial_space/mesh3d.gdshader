shader_type spatial;

uniform float speed : hint_range(0.1, 100.0) = 1.0;
uniform float frequency: hint_range(0.01, 100.0)=1.0;
instance uniform vec4 strip_color : source_color = vec4(1.0);
instance uniform float emissive_strength : hint_range(0.0, 10.0) = 0.5;

void fragment() {
	vec2 uv = UV;
	vec2 p = uv * frequency;
    float time = TIME * speed;



    // Generate rainbow colors based on the position and time
    //vec3 pos = FRAGCOORD.xyz * frequency;

    float r = sin(p.x + p.y + time) * 0.5 + 0.5;
    //float g = sin(pos.x + time + 2.0) * 0.5 + 0.5;
    //float b = sin(pos.x + pos.y + time + 4.0) * 0.5 + 0.5;

    ALBEDO = strip_color.rgb;
	if (r>0.5){
		ALPHA = 0.0;
	} else {
		ALPHA = strip_color.a;
		EMISSION = strip_color.rgb * emissive_strength;
	}

}
