extends Node2D
class_name ScorePopup

@export var rise_distance: float = 2.0
@export var duration: float = 1
@export var drift_range: float = 10.0
@export var scale_threshold: int = 50
@export var scale_max_value: int = 1500
@export var max_scale: float = 4.0

@onready var digits_renderer: DigitsRenderer = $DigitsRenderer

func setup(amount: int) -> void:
	digits_renderer.modulate = Color.WHITE if amount >= 0 else Color(1, 0.4, 0.4)
	digits_renderer.set_value(absi(amount))

	var value := absi(amount)
	var target_scale: float = 1.0
	if value > scale_threshold:
		var t := clampf(
			inverse_lerp(float(scale_threshold), float(scale_max_value), float(value)),
			0.0, 1.0
		)
		target_scale = lerpf(1.0, max_scale, t)
	digits_renderer.scale = Vector2.ONE * target_scale

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
