extends Control
@export var game_scene_path: String = "res://node_2d.tscn"  # caminho da sua cena do jogo
@onready var difficulty_select: OptionButton = $CenterContainer/VBoxContainer/DifficultySelect

func _ready() -> void:
	get_tree().paused = false
	
func _on_play_pressed() -> void:
	# como você já definiu IDs 0 (Fácil), 1 (Normal), 2 (Difícil):
	var id := difficulty_select.get_selected_id()
	GameController.set_difficulty(id)

	GameController.player1_points = 0
	GameController.player2_points = 0
	get_tree().change_scene_to_file(game_scene_path)

func _on_quit_pressed() -> void:
	get_tree().quit()
