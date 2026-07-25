extends Node2D
class_name SimonSequenceDisplay

# Draws the target pattern as a row of colored rectangles (no sprite/animation
# assets needed) and continuously loops through it: a white "get ready" flash,
# then each color in turn with a brief blank gap between them so repeated
# colors and turn boundaries are always visually distinct.

@export var colors: Array[Color] = []
@export var rect_size: Vector2 = Vector2(24, 24)
@export var rect_spacing: float = 8.0
@export var flash_interval: float = 0.5
@export var dim_alpha: float = 0.35
@export var highlight_scale: float = 1.25

@export_group("Intro flash")
@export var intro_flash_duration: float = 0.4
@export var intro_color: Color = Color.WHITE

@export_group("Gap between colors")
@export var gap_duration: float = 0.15

enum StepType { INTRO, COLOR, GAP }

var pattern: Array[int] = []

var _steps: Array[Dictionary] = []
var _step_index: int = 0
var _accumulator: float = 0.0

func set_pattern(new_pattern: Array[int]) -> void:
	pattern = new_pattern
	_build_steps()
	_step_index = 0
	_accumulator = 0.0
	queue_redraw()

func _build_steps() -> void:
	_steps.clear()
	if pattern.is_empty(): return

	_steps.append({"type": StepType.INTRO, "duration": intro_flash_duration})
	for i in pattern.size():
		_steps.append({"type": StepType.COLOR, "duration": flash_interval, "index": i})
		_steps.append({"type": StepType.GAP, "duration": gap_duration})

func _process(delta: float) -> void:
	if _steps.is_empty(): return
	if !GameManager.is_game_active(): return

	_accumulator += delta
	while _accumulator >= _steps[_step_index]["duration"]:
		_accumulator -= _steps[_step_index]["duration"]
		_step_index = (_step_index + 1) % _steps.size()
		queue_redraw()

func _draw() -> void:
	if _steps.is_empty(): return

	var current_step: Dictionary = _steps[_step_index]
	var step_type: StepType = current_step["type"]
	var highlight_index: int = current_step["index"] if step_type == StepType.COLOR else -1

	var slot: float = rect_size.x + rect_spacing

	for i in pattern.size():
		var color: Color = colors[pattern[i]]
		var size: Vector2 = rect_size

		match step_type:
			StepType.INTRO:
				color = intro_color
				size *= highlight_scale
			StepType.GAP:
				color.a = dim_alpha
			StepType.COLOR:
				if i == highlight_index:
					size *= highlight_scale
				else:
					color.a = dim_alpha

		var origin: Vector2 = Vector2(i * slot, 0) - (size - rect_size) * 0.5
		draw_rect(Rect2(origin, size), color)
