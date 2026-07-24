extends Node2D
class_name ScorePopup

@export var rise_distance: float = 2.0
@export var duration: float = 1
@export var drift_range: float = 10.0

@onready var digits_renderer: DigitsRenderer = $DigitsRenderer

func setup(amount: int) -> void:
	digits_renderer.modulate = Color.WHITE if amount >= 0 else Color(1, 0.4, 0.4)
	digits_renderer.set_value(amount)
	_animate()

func _animate() -> void:
	var drift := randf_range(-drift_range, drift_range)
	var target := position + Vector2(drift, -rise_distance)

	var tween := create_tween()
	tween.tween_property(self, "position", target, duration) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(digits_renderer, "modulate:a", 0.0, duration * 0.5) \
		.set_delay(duration * 0.5)
	tween.tween_callback(queue_free)
