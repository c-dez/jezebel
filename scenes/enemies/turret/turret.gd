extends CharacterBody3D


@export var speed: float = 4.0
@onready var detect_player_node: Node3D = get_node("DetectPlayer")

@onready var bullet := preload("res://assets/proyectiles/proyectile.tscn")
@onready var fire_timer := Timer.new()

@onready var navigation_point := preload("res://assets/navigation_poit.tscn")

func _ready() -> void:
	add_child(fire_timer)
	fire_timer.one_shot = true
	pass


func _physics_process(_delta: float) -> void:
	track_player(_delta)
	

func track_player(_delta) -> void:
	# cambiar : en vez de seguir posicion de jugador, seguir posicion de obj navigation_point que es hijo de navigation_logic_node 
	var player_position: Vector3 = detect_player_node.player_position
	if player_position != Vector3.ZERO:
		look_at(Vector3(player_position.x, position.y, player_position.z), Vector3(0, 1, 0), false)
		
		###  MOVES TO PLAYER GLOBAL POSITION
		# position += position.direction_to(Vector3(player_position.x, global_position.y, player_position.z)) * speed * _delta


	
	

