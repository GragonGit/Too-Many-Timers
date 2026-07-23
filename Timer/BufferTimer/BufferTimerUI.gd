extends AnimatedSprite2D

signal reset

@export var max_time: float = 10

var is_pressed: bool = false
var fill_ratio: float = 1.0

const BAR_WIDTH: float = 2.0
const BAR_HEIGHT: float = 10.0

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
	var current_fill_height: float = BAR_HEIGHT * fill_ratio

	var fill_rect = Rect2(
		-1,
		BAR_HEIGHT - current_fill_height -7,
		BAR_WIDTH, 
		current_fill_height
	)
	
	draw_rect(fill_rect, Color("f6d6bd"))


func _on_buffer_timer_value_changed(new_value: float) -> void:
	pass # Replace with function body.
