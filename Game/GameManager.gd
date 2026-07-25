extends Node

const TICK_INTERVAL: float = 1.0

@export var timers: Array[TimerSpawnData] = []
@export var spawn_parent: Node = null
@export var spawn_interval: int = 15
@export var tick_scale_increase: float = 0.1
var main_timer: Node
var rubber_duck: Node

var current_value: float = 0.0
var current_value_scaled: float = 0.0
var _accumulator: float = 0.0
var _accumulator_scaled: float = 0.0
var _tick_scale: float = 1.0
var _is_game_over: bool = true
var _is_game_paused: bool = false
var _last_spawn: float = 0.0

var _available_indices: Array[int] = []
var _spawned_timers: Array[Node] = []


func _ready() -> void:
	AudioManager.tick_speed(_tick_scale)
	_reset_available_timers()


func _process(delta: float) -> void:
	if !is_game_active(): return

	_accumulator += delta
	_accumulator_scaled += delta * _tick_scale
	while _accumulator >= TICK_INTERVAL:
		_accumulator -= TICK_INTERVAL
		_tick()
		if _is_game_over:
			break
	while _accumulator_scaled >= TICK_INTERVAL:
		_accumulator_scaled -= TICK_INTERVAL
		_tick_scaled()
		if _is_game_over:
			break


func is_game_active() -> bool:
	return !_is_game_over && !_is_game_paused

func reset() -> void:
	current_value = 0.0
	current_value_scaled = 0.0
	_tick_scale = 1.0
	_accumulator = 0.0
	_accumulator_scaled = 0.0
	_last_spawn = 0.0
	await _clear_spawned_timers()
	_reset_available_timers()
	AudioManager.tick_speed(_tick_scale)
	main_timer.connect("reset", retry)
	rubber_duck.reset()
	(main_timer.get_node("BaseTimer") as BaseTimer).restart()

func game_over() -> void:
	if _is_game_over: return
	_is_game_over = true
	AudioManager.on_game_over()
	await wait(4)
	reset()

func retry() -> void:
	main_timer.disconnect("reset", retry)
	AudioManager.start_tick_music()
	_is_game_over = false
	main_timer.reset.emit()
	ScoreManager.reset_score()

func game_pause(paused: bool) -> void:
	_is_game_paused = paused
	AudioManager.tick_music_paused(paused)

func _tick() -> void:
	current_value += TICK_INTERVAL
	if _should_spawn():
		_spawn_random_timer()
		_last_spawn = current_value

func _tick_scaled() -> void:
	current_value_scaled += TICK_INTERVAL
	ScoreManager.add_score(1)

func _increase_difficulty() -> void:
	_tick_scale += tick_scale_increase
	AudioManager.tick_speed(_tick_scale)


func _should_spawn() -> bool:
	return current_value - _last_spawn > spawn_interval


func _reset_available_timers() -> void:
	_available_indices.clear()
	for i in timers.size():
		_available_indices.append(i)


func _spawn_random_timer() -> void:
	if _available_indices.is_empty():
		_increase_difficulty()
		return

	var random_pos: int = randi() % _available_indices.size()
	var timer_index: int = _available_indices[random_pos]
	_available_indices.remove_at(random_pos)

	var spawn_data: TimerSpawnData = timers[timer_index]
	if spawn_data == null || spawn_data.timer_scene == null:
		push_warning("TimerSpawnData an Index %d ist unvollstaendig." % timer_index)
		return

	var timer: Node = spawn_data.timer_scene.instantiate()

	var parent: Node = spawn_parent if spawn_parent else self
	parent.add_child(timer)

	if "position" in timer:
		timer.position = spawn_data.position
	else:
		push_warning("Timer-Node hat keine 'position'-Property (kein Node2D/Control).")

	_spawned_timers.append(timer)


func _clear_spawned_timers() -> void:
	for timer in _spawned_timers:
		if is_instance_valid(timer):
			await wait(1)
			timer.die()
	_spawned_timers.clear()

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
