extends CharacterBody2D

@export var speed: float = 450.0        
@export var ball: Node2D                
@export var margin_y: float = 18.0      

var offset_y := 0.0
var last_ball_x := 0.0
var reaction_time := 0.12             
var max_speed_factor := 1.0            
var react_timer := 0.0

func _ready() -> void:
	
	var half_w := 0.0
	if has_node("Sprite2D"):
		var s: Sprite2D = $Sprite2D
		if s.texture:
			offset_y = (s.texture.get_height() * s.scale.y) / 2.0
			half_w   = (s.texture.get_width()  * s.scale.x) / 2.0

	
	var view_size := get_viewport_rect().size
	var right_margin := 16.0
	position.x = view_size.x - half_w - right_margin
	position.y = view_size.y / 2.0

	if Engine.has_singleton("GameController"):
		speed = GameController.get_paddle_speed()

		match GameController.difficulty:
			GameController.Difficulty.EASY:
				margin_y = 28.0
				reaction_time = 0.18
				max_speed_factor = 0.85
			GameController.Difficulty.NORMAL:
				margin_y = 18.0
				reaction_time = 0.12
				max_speed_factor = 1.0
			GameController.Difficulty.HARD:
				margin_y = 8.0
				reaction_time = 0.06
				max_speed_factor = 1.25

	
	if ball:
		last_ball_x = ball.position.x
	react_timer = reaction_time

func _physics_process(delta: float) -> void:
	if not ball:
		return

	
	var moving_towards := (ball.position.x - last_ball_x) > 0.0
	last_ball_x = ball.position.x

	if moving_towards:
		react_timer = max(react_timer - delta, 0.0)
	else:
		react_timer = reaction_time
		return

	if react_timer > 0.0:
		return

	var target_y := ball.position.y
	var dy := target_y - position.y

	if abs(dy) > margin_y:
		var step := speed * max_speed_factor * delta
		position.y += clamp(dy, -step, step)

	var h := get_viewport_rect().size.y
	position.y = clamp(position.y, offset_y, h - offset_y)
