extends Node

@onready var tick_music: AudioStreamPlayer = $TickMusic
@onready var tick_music_scaled: AudioStreamPlayer = $TickMusicScaled
@onready var times_up: AudioStreamPlayer = $TimesUp
@onready var bus_idx := AudioServer.get_bus_index(tick_music.bus)
@onready var initial_db := AudioServer.get_bus_volume_db(bus_idx)
@onready var pitch_shift_effect: AudioEffectPitchShift = AudioServer.get_bus_effect(bus_idx, 0)

var speed_tween: Tween

func start_tick_music() -> void:
	tick_music.play()

func stop_tick_music() -> void:
	tick_music.stop()

func tick_music_paused(paused: bool) -> void:
	tick_music.stream_paused = paused

func tick_speed(target_speed: float, duration: float = 1.0) -> void:
	if speed_tween:
		speed_tween.kill()
	speed_tween = create_tween()
	speed_tween.tween_method(
		_apply_speed, tick_music.pitch_scale, target_speed, duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _apply_speed(value: float) -> void:
	tick_music.pitch_scale = value
	if pitch_shift_effect:
		pitch_shift_effect.pitch_scale = 1.0 / value

func mute_music(mute: bool, duration: float = 0.1) -> void:
	var target_db := -80.0 if mute else initial_db
	var tween := create_tween()
	tween.tween_method(
		_apply_bus_volume, AudioServer.get_bus_volume_db(bus_idx), target_db, duration
	)

func _apply_bus_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_idx, value)
