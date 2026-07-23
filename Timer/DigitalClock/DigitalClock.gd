extends AnimatedSprite2D

signal reset

@export var digits_texture: CompressedTexture2D
@export var digit_size: Vector2i = Vector2i(3, 5)

var seconds0: int = 0
var seconds1: int = 0

func press_reset_button_area2d(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		reset.emit()

func on_value_changed(value: float) -> void:
	seconds0 = int(value) % 10
	seconds1 = int(value) / 10
	queue_redraw()

func _draw() -> void:
	var src0 := Rect2(Vector2(seconds0 * digit_size.x, 0), Vector2(digit_size))
	draw_texture_rect_region(digits_texture, Rect2(Vector2(1, -1), Vector2(digit_size)), src0)
	var src1 := Rect2(Vector2(seconds1 * digit_size.x, 0), Vector2(digit_size))
	draw_texture_rect_region(digits_texture, Rect2(Vector2(-4, -1), Vector2(digit_size)), src1)
