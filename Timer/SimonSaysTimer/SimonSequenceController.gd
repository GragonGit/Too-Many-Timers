extends Node
class_name SimonSequenceController

# Generates the random target pattern, listens to the color buttons, and
# resets the BaseTimer-derived node once the player enters the pattern
# correctly, start to finish, with no mistakes in between.

@export var pattern_length: int = 5
@export var color_count: int = 4

@export var timer_node: BaseTimer
@export var sequence_display: SimonSequenceDisplay
@export var buttons: Array[SimonButton] = []

var target_pattern: Array[int] = []
var _player_progress: int = 0

func _ready() -> void:
	for button in buttons:
		button.pressed.connect(_on_button_pressed)
	_generate_pattern()

func _on_button_pressed(button_id: int) -> void:
	if !timer_node.is_active(): return

	if button_id == target_pattern[_player_progress]:
		_player_progress += 1
		if _player_progress >= target_pattern.size():
			_on_sequence_completed()
	else:
		# Any mistake restarts the attempt from scratch. The target pattern
		# itself doesn't change, since it's always visible on the display.
		_player_progress = 0

func _on_sequence_completed() -> void:
	timer_node.press_reset_button()
	_player_progress = 0
	_generate_pattern()

func _generate_pattern() -> void:
	target_pattern.clear()
	var previous_color: int = -1
	for i in pattern_length:
		var next_color: int = randi() % color_count
		while next_color == previous_color:
			next_color = randi() % color_count
		target_pattern.append(next_color)
		previous_color = next_color
	sequence_display.set_pattern(target_pattern)
