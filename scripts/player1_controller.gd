extends CharacterBody2D

var offset_y = 0
@export var speed: float = 500.0

func _ready() -> void:
	offset_y = $Sprite2D.texture.get_height()/2
	speed = GameController.get_paddle_speed()

func _process(delta: float) -> void:
	if Input.is_action_pressed("move_down"):
		self.position.y += speed * delta
	
	if Input.is_action_pressed("move_up"):
		self.position.y -= speed * delta
	
	# Garantindo que ele não ultrapassa o limite superior da tela
	if self.position.y <= offset_y:
		self.position.y = offset_y
		
	# Garantindo que ele não ultrapassa o limite inferior da tela
	if self.position.y >= get_window().size.y - offset_y:
		self.position.y = get_window().size.y - offset_y
