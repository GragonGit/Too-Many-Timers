extends Node

@onready var tick_music: AudioStreamPlayer = $TickMusic
@onready var tick_music_db: float = tick_music.volume_db

func start_tick_music() -> void:
	tick_music.play()

func stop_tick_music() -> void:
	tick_music.stop()

func tick_music_paused(paused: bool) -> void:
	tick_music.stream_paused = paused

func tick_speed(speed: float) -> void:
	tick_music.pitch_scale = speed

func mute_tick_music(mute: bool) -> void:
	tick_music.volume_db = -80.0 if mute else tick_music_db
