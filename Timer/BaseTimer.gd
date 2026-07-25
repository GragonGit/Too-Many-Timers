extends Node
class_name BaseTimer

# SECTION Setup
# Signals
signal value_changed(new_value: float)
signal reset_pressed(new_value: float)

# Configuration
@export var reset_value: float = 60.0
@export var tick_interval: float = 1.0
@export var start_paused: bool = false

# Runtime State
var current_value: float = 0.0

var _accumulator: float = 0.0
var _is_running: bool = true

# !SECTION
# SECTION Godot Lifecycle
func _ready() -> void:
	_set_value(reset_value)
	_is_running = !start_paused


func _process(delta: float) -> void:
	if !is_active(): return

	_accumulator += delta * GameManager._tick_scale
	while _accumulator >= tick_interval:
		_accumulator -= tick_interval
		_tick()

		if GameManager._is_game_over:
			break

# !SECTION
# SECTION API
func press_reset_button() -> void:
	if !is_active(): return
	_on_reset_pressed()


func pause() -> void:
	_is_running = false


func resume() -> void:
	if !is_active(): return
	_is_running = true


func restart() -> void:
	_accumulator = 0.0
	_is_running = !start_paused
	_set_value(reset_value)


func get_value() -> float:
	return current_value


func is_active() -> bool:
	return _is_running && GameManager.is_game_active()

# !SECTION
# SECTION Virtual Methods
func _calculate_next_value(value: float) -> float:
	return value - 1.0

func _should_trigger_game_over(value: float) -> bool:
	return value <= 0.0

func _calculate_score(old_value: float) -> int:
	return roundi(current_value - old_value)

func _on_reset_pressed() -> void:
	var old_value = current_value
	_set_value(reset_value)
	ScoreManager.add_score(_calculate_score(old_value))
	reset_pressed.emit(current_value)

# NOTE - It is recommended to _overwrite calculate_next_value() and _should_trigger_game_over() instead
func _tick() -> void:
	var next_value: float = _calculate_next_value(current_value)
	_set_value(next_value)

	if _should_trigger_game_over(current_value):
		GameManager.game_over()

func _set_value(new_value: float) -> void:
	current_value = new_value
	value_changed.emit(current_value)
# !SECTION
