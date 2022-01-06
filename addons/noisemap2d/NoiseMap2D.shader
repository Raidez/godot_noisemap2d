shader_type canvas_item;

uniform sampler2D gradient;

void fragment() {
	// get the current pixel value to a sample (0 to 1)
	vec4 current_color = texture(TEXTURE, UV);
	float sample = (current_color.r + current_color.g + current_color.b) / 3.0;
	
	// get the color from gradient
	vec4 target_color = texture(gradient, vec2(sample, 0));
	COLOR = target_color;
}