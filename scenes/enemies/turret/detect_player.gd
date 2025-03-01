extends Node3D


@onready var shape_cast:ShapeCast3D = get_node("ShapeCast3D")
@onready var parent:Node3D = get_node("..")
var player_position: Vector3 = Vector3.ZERO

@onready var timer:Timer = Timer.new()
var timer_cooldown:float = 1.5


func _ready() -> void:
	add_child(timer)
	timer.one_shot =true
	pass

func _physics_process(_delta: float) -> void:
	get_position_of_player()

	# Shapecast no es la herramienta correcta, seria mejor usar Area3D
func get_position_of_player()->void:
	if shape_cast.is_colliding():
		timer.start(timer_cooldown)
		player_position = shape_cast.get_collision_point(0)

	
	if timer.is_stopped() ==  true and shape_cast.is_colliding() == false:
		player_position = Vector3.ZERO
	print(parent.name)
	
	if parent.global_position == Vector3(player_position.x,parent.global_position.y,player_position.z):
		# PROBLEMA al llegar acercarse al punto no llega exacto, se pasa, regresa, pero se pasa otra vez y repite esto hasta que el timer expira, lo que crea glitch
		
		player_position = Vector3.ZERO
		pass