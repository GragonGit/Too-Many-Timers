extends AnimatedSprite2D

signal reset

@export var bit_count: int = 4
@export var square_size: float = 4.0
@export var square_spacing: float = 4.0
@export var color_on: Color = Color("f9d381")
@export var color_off: Color = Color(Color("f9d381"), 0.0)

var is_pressed: bool = false
var current_value: int = 0

func press_reset_button_area2d(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if GameManager._is_game_paused: return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			is_pressed = true
			play("press")
			reset.emit()
		elif event.is_released():
			is_pressed = false
			play("release")

func _on_area_2d_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func on_mouse_exited_reset_button_area2d() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	if is_pressed:
		is_pressed = false
		play("release")

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
