extends CharacterBody3D


@export var speed: float = 4.0
@onready var detect_player_node: Node3D = get_node("DetectPlayer")

func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	track_player(_delta)

func track_player(_delta) -> void:
	#var player_position: Vector3 = get_node("DetectPlayer").player_position
	var player_position: Vector3 = detect_player_node.player_position
	if player_position != Vector3.ZERO:
		look_at(Vector3(player_position.x, position.y, player_position.z), Vector3(0, 1, 0), false)
		
		###  MOVES TO PLAYER GLOBAL POSITION
		position += position.direction_to(Vector3(player_position.x, global_position.y, player_position.z)) * speed * _delta

	### Disparar bala a la posicion de jugador 

	# cada 3 segundos  despues de ver jugador tomar una posicion y disparar
