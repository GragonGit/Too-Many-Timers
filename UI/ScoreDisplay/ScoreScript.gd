extends Node2D

@export var digits_texture: CompressedTexture2D
@export var digit_size: Vector2i = Vector2i(3, 5)
@export var digit_spacing: int = 2
@export var min_digits: int = 10

var digits: Array[int] = []

func _ready() -> void:
	ScoreManager.score_changed.connect(_on_score_changed)
	_on_score_changed(ScoreManager.score)

func _on_score_changed(value: int) -> void:
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
		var dst := Rect2(Vector2(1 - i * step, -1), Vector2(digit_size))
		draw_texture_rect_region(digits_texture, dst, src)
