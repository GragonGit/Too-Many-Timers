extends TimerSprite2D

@export var bit_count: int = 4
@export var square_size: float = 4.0
@export var square_spacing: float = 4.0
@export var color_on: Color = Color("f9d381")
@export var color_off: Color = Color(Color("f9d381"), 0.0)

var current_value: int = 0

func on_value_changed(value: float) -> void:
	current_value = max(0, int(value))
	queue_redraw()

func _draw() -> void:
	var total_width := bit_count * square_size + (bit_count - 1) * square_spacing
	var start_x := -total_width / 2.0 - 6
	var y := -square_size / 2.0 + 6

	for i in range(bit_count):
		var bit_index := bit_count - 1 - i
		var bit_value := (current_value >> bit_index) & 1
		var x := start_x + i * (square_size + square_spacing)
		var rect := Rect2(x, y, square_size, square_size)

		if bit_value == 1:
			draw_rect(rect, color_on)
		else:
			draw_rect(rect, color_off)
