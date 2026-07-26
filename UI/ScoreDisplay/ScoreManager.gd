extends Node

signal score_changed(new_score: int)
signal high_score_changed(new_high_score: int)

var score: int = 0
var high_score: int = 0
var multiplier: int = 1

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
