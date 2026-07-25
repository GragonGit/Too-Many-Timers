extends Sprite2D

@export var line_origin: Vector2 = Vector2.ZERO
@export var line_color: Color = Color.BLACK
@export var line_length: float = 19.0
@export var line_width: float = 2.0
@export var value_max: float = 12.0

var _is_dying: bool = false
var _value: float = 0.0

func on_value_change(value: float) -> void:
	_value = value
	queue_redraw()

func die() -> void:
	if _is_dying:
		return
	_is_dying = true

	var entry_anim: AnimatedSprite2D = get_node_or_null("EntryAnimation")
	if entry_anim:
		entry_anim.play("exit")
		await entry_anim.animation_finished

	queue_free()

func _draw() -> void:
	var angle: float = (_value / value_max) * PI
	var direction: Vector2 = Vector2.UP.rotated(angle)
	var end_point: Vector2 = line_origin + direction * line_length

	draw_line(line_origin, end_point, line_color, line_width)
