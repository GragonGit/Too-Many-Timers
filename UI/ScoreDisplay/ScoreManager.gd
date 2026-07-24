extends Node

signal score_changed(new_score: int)
signal high_score_changed(new_high_score: int)

var score: int = 0
var high_score: int = 0

func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)
	if high_score < score:
		high_score = score
		high_score_changed.emit(high_score)

func reset_score() -> void:
	score = 0
	score_changed.emit(score)
