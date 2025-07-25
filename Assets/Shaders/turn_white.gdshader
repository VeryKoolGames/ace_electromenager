shader_type canvas_item;

uniform float white_progress : hint_range(0, 1) = 0;

void fragment() {
    vec4 origin = texture(TEXTURE, UV);
	if (origin.a > 0.5) {
	    COLOR.rgb = mix(origin.rgb, vec3(1.0, 1.0, 1.0), white_progress);
	   	COLOR.a = origin.a;
	}
}