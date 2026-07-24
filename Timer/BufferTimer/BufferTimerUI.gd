extends AnimatedSprite2D

signal reset

@export var max_time: float = 10

var is_pressed: bool = false
var fill_ratio: float = 1.0

const BAR_WIDTH: float = 4.0
const BAR_HEIGHT: float = 29.0
const SQUARE_SIZE: float = 2.0
const SQUARE_GAP: float = 1.0

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

func on_mouse_exited_reset_button_area2d() -> void:
	if is_pressed:
		is_pressed = false
		play("release")

func on_value_changed(value: float) -> void:
	fill_ratio = clamp(value / max_time, 0.0, 1.0)
	queue_redraw()

func _draw() -> void:
	var square_count: int = int((BAR_HEIGHT + SQUARE_GAP) / (SQUARE_SIZE + SQUARE_GAP))
	var filled_count: int = int(round(fill_ratio * square_count))

	for i in range(square_count):
		var y_bottom: float = BAR_HEIGHT - i * (SQUARE_SIZE + SQUARE_GAP)
		var y_top: float = y_bottom - SQUARE_SIZE - 25

		var square_rect := Rect2(-2, y_top, BAR_WIDTH, SQUARE_SIZE)

		if i < filled_count:
			draw_rect(square_rect, Color("e75952"))
		else:
			draw_rect(square_rect, Color(Color("e75952"), 0.15))
