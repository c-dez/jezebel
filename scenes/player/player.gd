extends CharacterBody3D

### SE ENCARGA DE LAS ACCIONES DE EL JUGADOR
## MOVIMIENTO
## ATAQUE

@export_group("Movement")
@export var speed: float = 7.0
@export var jump_height: float
@export var jump_time_to_peak: float
@export var jump_time_to_decend: float

@onready var jump_velocity: float = (2.0 * jump_height) / jump_time_to_peak
@onready var jump_gravity: float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity: float = (-2.0 * jump_height) / (jump_time_to_decend * jump_time_to_decend)


var mouse_1: String = "mouse_1"
var mouse_2: String = "mouse_2"
var move_jump: String = "move_jump"

var joy_r_trigger: String = "joy_r_trigger"
var joy_move_jump: String = "joy_l_trigger"

@onready var camera_arm: Node3D = get_node("CameraArm")
@onready var control_manager: Node = get_node("ControlManager")
@onready var bat_hit_box :Area3D = get_node("BatHitBox")

### attack attack_cooldown 
@onready var attack_timer: Timer = Timer.new()
@export_group("Attack cooldown")
@export var attack_cooldown:float = 1.5






# TODO: terminar control con gamepad, movimiento que sea en float
# TODO: attack() animacion y hitbox, crear enemigo que dispare y los proyectiles "batearlos"

func _ready() -> void:
	# attack_timer = Timer.new()
	add_child(attack_timer)
	attack_timer.one_shot = true

	bat_hit_box.monitoring =false
	pass

func _process(_delta: float) -> void:
	attack()


func _physics_process(delta: float) -> void:
	move_player()
	jump()
	gravity(delta)
	move_and_slide()


func attack() -> void:
	var _attack: String = mouse_1
	# quitar estas variables y hacer referencia directa al enum que se quiere comparar
	var control_is_mouse: int = 0
	var control_is_gamepad: int = 1
	####  control_manager es una variable que cambia segun a un state machine en nodo ControlManager para decidir tipo de control
	if control_manager.control_type == control_is_mouse:
		_attack = mouse_1
	if control_manager.control_type == control_is_gamepad:
		_attack = joy_r_trigger

	if Input.is_action_just_pressed(_attack) and attack_timer.is_stopped() :
		# con este bloque ejecuto codigo y evito que usuario lo vuelva a ejecutar hasta que pase x tiempo
		attack_timer.start(attack_cooldown)
		# print("do attack")
	if attack_timer.is_stopped() == false:
		### Enciende monitoreo y devuelvee un array con los bodies dentro de el HitBox
		bat_hit_box.monitoring = true
		### Aqui tomo en bodie deseado y le doy las propiedades requeridas("desviar el proyectil")

		# print(bat_hit_box.get_overlapping_bodies())
		

	
		pass







func jump() -> void:
	var _jump: String = move_jump
	var control_is_mouse: int = 0
	var control_is_gamepad: int = 1
	####  control_manager es una variable que cambia segun a un state machine en nodo ControlManager para decidir tipo de control
	if control_manager.control_type == control_is_mouse:
		_jump = move_jump
	if control_manager.control_type == control_is_gamepad:
		_jump = joy_move_jump
	if Input.is_action_just_pressed(_jump) and is_on_floor():
		# velocity.y = jump_velocity
		velocity.y = jump_velocity


func move_player() -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction != Vector3.ZERO:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

func gravity(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += Vector3(0, better_gravity(), 0) * delta

func better_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity
