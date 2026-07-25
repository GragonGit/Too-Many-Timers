extends HSlider

@export var grabber_half_width: float = 8.0

@export var grabber_normal_icon: Texture2D
@export var grabber_min_icon: Texture2D

func _ready() -> void:
	value_changed.emit(value)

func _has_point(point: Vector2) -> bool:
	var expanded_rect := Rect2(
		Vector2(-grabber_half_width, 0),
		size + Vector2(grabber_half_width * 2, 0)
	)
	return expanded_rect.has_point(point)

func _update_grabber_icon(current_value: float) -> void:
	if is_equal_approx(current_value, min_value):
		add_theme_icon_override("grabber", grabber_min_icon)
		add_theme_icon_override("grabber_highlight", grabber_min_icon)
	else:
		add_theme_icon_override("grabber", grabber_normal_icon)
		add_theme_icon_override("grabber_highlight", grabber_normal_icon)
