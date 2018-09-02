vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
	vec4 pixel = Texel(texture, texture_coords );
	return vec4(pixel.r * 0.5, pixel.g * 0.5, pixel.b * 0.5, 1.0);
}
