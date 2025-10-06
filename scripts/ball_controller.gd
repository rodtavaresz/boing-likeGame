extends RigidBody2D

@export var speed: float = 520.0
@export var max_bounce_angle := deg_to_rad(60)
@export var player1_label: Label
@export var player2_label: Label
@export var max_points: int = 5
@export var game_over_label: Label
@export var game_over_panel: CanvasLayer

var velocity := Vector2.ZERO
var game_over := false

func _ready() -> void:
	get_tree().paused = false
	if Engine.has_singleton("GameController"):
		speed = GameController.get_ball_speed()
	randomize()
	var dir_x := -1.0 if randf() < 0.5 else 1.0
	var angle := randf_range(-PI/6, PI/6)
	velocity = Vector2(dir_x, 0).rotated(angle) * speed
	_prepare_game_over_ui()
	if player1_label and player2_label:
		if player1_label.global_position.x > player2_label.global_position.x:
			var tmp := player1_label
			player1_label = player2_label
			player2_label = tmp
	_update_hud()
	

func reset_ball_position() -> void:
	position = get_window().size / 2
	velocity = Vector2.ZERO
	if game_over:
		return
	await get_tree().create_timer(1.5).timeout
	var dir_x := -1.0 if randf() < 0.5 else 1.0
	var angle := randf_range(-PI/6, PI/6)
	velocity = Vector2(dir_x, 0).rotated(angle) * speed

func _physics_process(delta: float) -> void:
	if position.x <= 0:
		GameController.player2_points += 1
		_update_hud()
		if GameController.player2_points >= max_points:
			_end_game("PLAYER 2")
		else:
			reset_ball_position()
		return
 
	if position.x >= get_window().size.x:
		GameController.player1_points += 1
		_update_hud()
		if GameController.player1_points >= max_points:
			_end_game("PLAYER 1")
		else:
			reset_ball_position()
		return

	var collision = move_and_collide(velocity * delta)
	if collision:
		var n = collision.get_normal()
		var collider = collision.get_collider()
		if collider != null:
			velocity = velocity.bounce(n)




func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().paused = false
		GameController.player1_points = 0
		GameController.player2_points = 0
		get_tree().reload_current_scene()

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	GameController.player1_points = 0
	GameController.player2_points = 0
	get_tree().reload_current_scene()

func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu.tscn")

func _force_when_paused_recursive(n: Node) -> void:
	n.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	for c in n.get_children():
		_force_when_paused_recursive(c)

func _prepare_game_over_ui() -> void:
	if not game_over_panel:
		return
	_force_when_paused_recursive(game_over_panel)
	var bg: ColorRect = game_over_panel.find_child("ColorRect", true, false)
	if bg:
		bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var restart: Button = game_over_panel.find_child("RestartButton", true, false)
	var menu: Button = game_over_panel.find_child("MenuButton", true, false)
	if restart and not restart.pressed.is_connected(_on_restart_button_pressed):
		restart.pressed.connect(_on_restart_button_pressed)
	if menu and not menu.pressed.is_connected(_on_menu_button_pressed):
		menu.pressed.connect(_on_menu_button_pressed)

func _end_game(winner: String) -> void:
	game_over = true
	velocity = Vector2.ZERO
	if game_over_label:
		game_over_label.text = winner + " VENCEU!"
		game_over_label.visible = true
	if game_over_panel:
		_prepare_game_over_ui()
		game_over_panel.visible = true

	get_tree().paused = true

func _update_hud() -> void:
	if player1_label:
		player1_label.text = "PLAYER 1: " + str(GameController.player1_points)
	if player2_label:
		player2_label.text = "PLAYER 2: " + str(GameController.player2_points)
