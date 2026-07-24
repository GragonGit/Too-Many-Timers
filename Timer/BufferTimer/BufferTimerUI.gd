extends TimerSprite2D

@export var max_time: float = 10

var fill_ratio: float = 1.0

const BAR_WIDTH: float = 4.0
const BAR_HEIGHT: float = 29.0
const SQUARE_SIZE: float = 2.0
const SQUARE_GAP: float = 1.0

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
