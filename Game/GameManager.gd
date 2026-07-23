extends Node

const TICK_INTERVAL: float = 1.0

@export var timers: Array[PackedScene] = []
@export var spawn_parent: Node = null
@export var spawn_interval: int = 15

var current_value: float = 0.0
var _accumulator: float = 0.0
var _is_game_over: bool = false
var _last_spawn: float = 0.0

var _available_indices: Array[int] = []
var _spawned_timers: Array[Node] = []


func _ready() -> void:
	_reset_available_timers()


func _process(delta: float) -> void:
	if _is_game_over:
		return
	_accumulator += delta
	while _accumulator >= TICK_INTERVAL:
		_accumulator -= TICK_INTERVAL
		_tick()
		if _is_game_over:
			break


func restart() -> void:
	current_value = 0.0
	_is_game_over = false
	_accumulator = 0.0
	_last_spawn = 0.0
	_clear_spawned_timers()
	_reset_available_timers()


func _tick() -> void:
	current_value += TICK_INTERVAL
	ScoreManager.add_score(1)
	if _should_spawn():
		_spawn_random_timer()
		_last_spawn = current_value


func _should_spawn() -> bool:
	return current_value - _last_spawn > spawn_interval


func _reset_available_timers() -> void:
	_available_indices.clear()
	for i in timers.size():
		_available_indices.append(i)


func _spawn_random_timer() -> void:
	print(_available_indices.size())
	if _available_indices.is_empty():
		return

	var random_pos: int = randi() % _available_indices.size()
	var timer_index: int = _available_indices[random_pos]
	_available_indices.remove_at(random_pos)

	var timer_scene: PackedScene = timers[timer_index]
	var timer: Node = timer_scene.instantiate()

	var parent: Node = spawn_parent if spawn_parent else self
	parent.add_child(timer)

	_spawned_timers.append(timer)


func _clear_spawned_timers() -> void:
	for timer in _spawned_timers:
		if is_instance_valid(timer):
			timer.queue_free()
	_spawned_timers.clear()
