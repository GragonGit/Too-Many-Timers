extends Node

@onready var tick_music: AudioStreamPlayer = $TickMusic
@onready var tick_music_scaled: AudioStreamPlayer = $TickMusicScaled
@onready var times_up: AudioStreamPlayer = $TimesUp
@onready var bus_idx := AudioServer.get_bus_index(tick_music.bus)
@onready var initial_db := AudioServer.get_bus_volume_db(bus_idx)
@onready var pitch_shift_effect: AudioEffectPitchShift = AudioServer.get_bus_effect(bus_idx, 0)

var speed_tween: Tween
var mute_tween: Tween
var using_scaled_music := false

func start_tick_music() -> void:
	tick_music.play()

func stop_tick_music() -> void:
	tick_music.stop()
	tick_music_scaled.stop()

func tick_music_paused(paused: bool) -> void:
	tick_music.stream_paused = paused
	tick_music_scaled.stream_paused = paused

func tick_speed(target_speed: float, duration: float = 1.0) -> void:
	if speed_tween:
		speed_tween.kill()

	var should_use_scaled := target_speed != 1.0
	if should_use_scaled != using_scaled_music:
		_switch_active_player(should_use_scaled)

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

func mute_music(mute: bool, duration: float = 0.1) -> void:
	if mute_tween:
		mute_tween.kill()

	var target_db := -80.0 if mute else initial_db
	mute_tween = create_tween()
	mute_tween.tween_method(
		_apply_bus_volume, AudioServer.get_bus_volume_db(bus_idx), target_db, duration
	)

func on_game_over() -> void:
	tick_music.stop()
	tick_music_scaled.stop()
	_apply_speed(1)
	if using_scaled_music:
		using_scaled_music = false
		times_up.play()

func _apply_bus_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_idx, value)
