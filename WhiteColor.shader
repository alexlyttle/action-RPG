shader_type canvas_item;

uniform bool active = true;

void fragment() {
	vec4 color = texture(TEXTURE, UV);  // Goes to sprite and gives color of each pixel
	if (active == true) {
		// Ususally best to avoid if statements in shader but okay here
		color = vec4(1.0, 1.0, 1.0, color.a);
	}
	COLOR = color;  // (RGBA) Sets every pixel to this color, white with previous alpha
}
