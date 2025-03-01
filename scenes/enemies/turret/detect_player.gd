extends Node3D


@onready var shape_cast: ShapeCast3D = get_node("ShapeCast3D")
@onready var navigation_logic_node: Node3D = get_node("NavigationLogic")
@onready var navigation_point: PackedScene = preload("res://assets/navigation_poit.tscn")
@onready var timer: Timer = Timer.new()
var player_position: Vector3 = Vector3.ZERO
var timer_cooldown: float = 1.5
var player_vector := Vector3.ZERO


func _ready() -> void:
	add_child(timer)
	timer.one_shot = true


func _physics_process(_delta: float) -> void:
	get_position_of_player()
	create_navigation_point(player_position)


func get_position_of_player() -> void:
	### Global position of player
	if shape_cast.is_colliding():
		# Shapecast no es la herramienta correcta, seria mejor usar Area3D
		var player_position_array: Array = []
		var max_size: int = 1
		timer.start(timer_cooldown)
		for i in range(max_size):
			player_position_array.append(shape_cast.get_collision_point(0))
		player_position = player_position_array[0]
	if timer.is_stopped() and !shape_cast.is_colliding():
		player_position = Vector3.ZERO

	
func create_navigation_point(_player_position: Vector3) -> void:
	if _player_position != Vector3.ZERO:
		### instancea un area3d en el global position de jugador
		var _navigation_point: Node3D = navigation_point.instantiate()
		navigation_logic_node.add_child(_navigation_point)
		_navigation_point.global_position = _player_position
		_navigation_point.top_level = true
		if navigation_logic_node.get_child_count() > 1:
			### Se encarga de que solo exista una instancia de area3d y que sea la ultima posicion de jugador
			navigation_logic_node.get_child(0).queue_free()
