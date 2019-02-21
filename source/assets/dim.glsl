vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
	vec4 pixel = Texel(texture, texture_coords );
	return vec4(pixel.r * 0.3, pixel.g * 0.3, pixel.b * 0.3, 1.0);
}
