extends Node

@onready var tick_music: AudioStreamPlayer = $TickMusic
@onready var tick_music_scaled: AudioStreamPlayer = $TickMusicScaled
@onready var times_up: AudioStreamPlayer = $TimesUp
@onready var take_your_time: AudioStreamPlayer = $TakeYourTime
@onready var click: AudioStreamPlayer = $Click
@onready var clack: AudioStreamPlayer = $Clack
@onready var duck_down: AudioStreamPlayer = $RubberDuckDown
@onready var duck_up: AudioStreamPlayer = $RubberDuckUp
@onready var bus_idx := AudioServer.get_bus_index(tick_music.bus)
@onready var initial_db := AudioServer.get_bus_volume_db(bus_idx)
@onready var pitch_shift_effect: AudioEffectPitchShift = AudioServer.get_bus_effect(bus_idx, 0)

var speed_tween: Tween
var mute_tween: Tween
var using_scaled_music := false

func _ready() -> void:
	GameManager.tick_scale_changed.connect(tick_speed)

func start_tick_music() -> void:
	tick_music.play()

func stop_tick_music() -> void:
	tick_music.stop()
	tick_music_scaled.stop()
	take_your_time.stop()

func tick_music_paused(paused: bool) -> void:
	var active_player := tick_music_scaled if using_scaled_music else tick_music

	if paused:
		active_player.stream_paused = true
		AudioServer.set_bus_effect_enabled(bus_idx, 0, false)
		take_your_time.play()
	else:
		take_your_time.stop()
		AudioServer.set_bus_effect_enabled(bus_idx, 0, true)
		active_player.stream_paused = false

func tick_speed(target_speed: float, duration: float = 1.0) -> void:
	if target_speed == 1.0: return
	if speed_tween:
		speed_tween.kill()

	if !using_scaled_music:
		_switch_active_player(true)

	speed_tween = create_tween()
	speed_tween.tween_method(
		_apply_speed, tick_music_scaled.pitch_scale, target_speed, duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _switch_active_player(use_scaled: bool) -> void:
	var from_player := tick_music if use_scaled else tick_music_scaled
	var to_player := tick_music_scaled if use_scaled else tick_music

	var was_playing := from_player.playing

	from_player.stop()

	if was_playing:
		to_player.play()

	to_player.stream_paused = from_player.stream_paused

	using_scaled_music = use_scaled

func _apply_speed(value: float) -> void:
	tick_music_scaled.pitch_scale = value
	if pitch_shift_effect:
		pitch_shift_effect.pitch_scale = 1.0 / value

func set_music_db(db: float, duration: float = 0.1) -> void:
	if mute_tween:
		mute_tween.kill()

	mute_tween = create_tween()
	mute_tween.tween_method(
		_apply_bus_volume, AudioServer.get_bus_volume_db(bus_idx), db, duration
	)

func on_game_over() -> void:
	tick_music.stop()
	tick_music_scaled.stop()
	take_your_time.stop()
	if speed_tween:
		speed_tween.kill()
	_apply_speed(1)
	if using_scaled_music:
		using_scaled_music = false
		times_up.play()

func _apply_bus_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_idx, value)

func on_button_down() -> void:
	click.play()

func on_button_up() -> void:
	clack.play()

func on_duck_down() -> void:
	duck_down.play()

func on_duck_up() -> void:
	duck_up.play()
