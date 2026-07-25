extends AnimatedSprite2D
class_name SimonButton

# One of the N clickable color buttons the player uses to input the sequence.
# Structurally identical to TimerSprite2D (Area2D + CollisionShape2D child,
# press/release animation, cursor feedback) but decoupled from "reset" and
# parameterized by an id so a controller can tell buttons apart.

signal pressed(button_id: int)

@export var button_id: int = 0

var is_pressed: bool = false

# Connect Area2D's "input_event" signal to this (Godot suggests this exact
# name automatically if the child is named "Area2D").
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if GameManager._is_game_paused: return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			is_pressed = true
			AudioManager.on_button_down()
			play("press")
			pressed.emit(button_id)
		elif event.is_released():
			is_pressed = false
			AudioManager.on_button_up()
			play("release")

func _on_area_2d_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_area_2d_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	if is_pressed:
		is_pressed = false
		AudioManager.on_button_up()
		play("release")
