extends Node

var player1_points = 0
var player2_points = 0

enum Difficulty { EASY, NORMAL, HARD }
var difficulty: int = Difficulty.NORMAL

var ball_speed_by_diff := {
	Difficulty.EASY:   180.0,
	Difficulty.NORMAL: 220.0,
	Difficulty.HARD:   500.0,
}
var paddle_speed_by_diff := {
	Difficulty.EASY:   300.0,
	Difficulty.NORMAL: 500.0,
	Difficulty.HARD:   850.0,
}

func set_difficulty(d: int) -> void:
	difficulty = d

func get_ball_speed() -> float:
	return ball_speed_by_diff[difficulty]

func get_paddle_speed() -> float:
	return paddle_speed_by_diff[difficulty]
