extends AnimatedSprite2D

signal reset

@export var digits_texture: CompressedTexture2D
@export var digit_size: Vector2i = Vector2i(3, 5)

var seconds0: int = 0
var seconds1: int = 0
var is_pressed: bool = false

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
	seconds0 = int(value) % 10
	seconds1 = int(value / 10.0)
	queue_redraw()

func _draw() -> void:
	var src0 := Rect2(Vector2(seconds0 * digit_size.x, 0), Vector2(digit_size))
	draw_texture_rect_region(digits_texture, Rect2(Vector2(1, 12), Vector2(digit_size)), src0)
	var src1 := Rect2(Vector2(seconds1 * digit_size.x, 0), Vector2(digit_size))
	draw_texture_rect_region(digits_texture, Rect2(Vector2(-7, 12), Vector2(digit_size)), src1)
