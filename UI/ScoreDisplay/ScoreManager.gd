extends Node

signal score_changed(new_score: int)
signal high_score_changed(new_high_score: int)

const SAVE_PATH: String = "user://highscore.save"

var score: int = 0
var high_score: int = 0
var multiplier: int = 1


func _ready() -> void:
	_load_high_score()


func add_score(amount: int, with_mult: bool = true) -> void:
	if amount == 0: return

	if with_mult:
		score += amount * multiplier
	else:
		score += amount
	score_changed.emit(score)

	if high_score < score:
		high_score = score
		high_score_changed.emit(high_score)


func reset_score() -> void:
	multiplier = 1
	score = 0
	score_changed.emit(score)


func set_multiplier(mult: int) -> void:
	multiplier = mult


func _save_high_score() -> void:
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(high_score)
		file.close()

	if OS.has_feature("web"):
		JavaScriptBridge.eval("FS.syncfs(function(err) {});")


func _load_high_score() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		high_score = file.get_var()
		file.close()
		high_score_changed.emit(high_score)
