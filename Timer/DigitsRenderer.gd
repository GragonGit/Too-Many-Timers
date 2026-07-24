extends Node2D
class_name DigitsRenderer

@export var digits_texture: CompressedTexture2D
@export var digit_size: Vector2i = Vector2i(3, 5)
@export var digit_spacing: int = 2
@export var min_digits: int = 2

var digits: Array[int] = []

func _ready() -> void:
	set_value(0)

func set_value_f(value: float) -> void:
	set_value(int(value))

func set_value(value: int) -> void:
	digits.clear()
	var v: int = maxi(value, 0)
	while v > 0 or digits.size() < 1:
		digits.append(v % 10)
		v /= 10
	while digits.size() < min_digits:
		digits.append(0)
	queue_redraw()

func _draw() -> void:
	var step: int = digit_size.x + digit_spacing
	for i in digits.size():
		var src := Rect2(Vector2(digits[i] * digit_size.x, 0), Vector2(digit_size))
		var dst := Rect2(Vector2(-i * step - digit_size.x, 0), Vector2(digit_size))
		draw_texture_rect_region(digits_texture, dst, src)
