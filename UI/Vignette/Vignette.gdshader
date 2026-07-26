shader_type canvas_item;

uniform float rect_alpha : hint_range(0.0, 1.0) = 0.0;
uniform vec2 rect_pos = vec2(0.0);
uniform vec2 rect_size = vec2(0.0);

uniform float spot_alpha : hint_range(0.0, 1.0) = 0.0;
uniform vec2 spot_pos = vec2(0.0);
uniform float spot_radius = 0.0;

uniform float edge_softness : hint_range(0.0, 64.0) = 1.0;

void fragment() {
	vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 pixel_pos = SCREEN_UV * screen_size;

	vec2 rect_min = rect_pos;
	vec2 rect_max = rect_pos + rect_size;
	float dist_x = max(rect_min.x - pixel_pos.x, pixel_pos.x - rect_max.x);
	float dist_y = max(rect_min.y - pixel_pos.y, pixel_pos.y - rect_max.y);
	float rect_dist = max(dist_x, dist_y);
	float rect_mask = smoothstep(0.0, max(edge_softness, 0.001), rect_dist);

	float circle_dist = distance(pixel_pos, spot_pos) - spot_radius;
	float circle_mask = smoothstep(0.0, max(edge_softness, 0.001), circle_dist);

	float a_rect = rect_alpha * rect_mask;
	float a_spot = spot_alpha * circle_mask;

	float final_alpha = max(a_rect, a_spot);

	COLOR = vec4(0.0, 0.0, 0.0, final_alpha);
}
