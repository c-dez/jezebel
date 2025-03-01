extends SpringArm3D
# SE ENCARGA DE EL MOVIMIENTO DE LA CAMARA MANEJADA POR MOUSE
# SE ENCARGA DE ROTAR EL MESH DE NODO PLAYER PARA CREAR LA ILUSION DE QUE LA CAMARA GIRA ALRREDEDOR DE PLAYER --QUIZAS SEA MEJOR QUE ESTO SE HICIERA DESDE NODO PLAYER

@onready var player: CharacterBody3D = get_node("..")

@export var x_sens: float = 0.09
@export var y_sens: float = 0.09
# @export var camera_weight:float = 0.1
var look_up_deg: int = 50
var look_down_deg: int = -70

@onready var control_manager := get_node("../ControlManager")


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(_delta: float) -> void:
	# _process(delta)?
	gamepad_camera_control()


func _unhandled_input(event: InputEvent) -> void:
	mouse_camera_control(event)


func mouse_camera_control(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.relative:
			var mouse_relative: Vector2 = event.relative
			# rotates player in horizontal
			player.rotate_y(deg_to_rad(-mouse_relative.x * x_sens))
			# rotate camera vertical / clamp
			# conversion de grados a radiantes solo por conveniencia
			var max_rad: float = deg_to_rad(look_up_deg)
			var min_rad: float = deg_to_rad(look_down_deg)
			rotate_x(deg_to_rad(-mouse_relative.y * y_sens))
			rotation.x = clamp(rotation.x, min_rad, max_rad)
			rotation.z = clamp(0, 0, 0)


func gamepad_camera_control() -> void:
	if control_manager.control_type == control_manager.CONTROLLER_TYPE.GAMEPAD:
		var joy_camera_x_input: float = Input.get_axis("joy_camera_x_negative", "joy_camera_x_positive")
		var joy_camera_y_input: float = Input.get_axis("joy_camera_y_negative", "joy_camera_y_positive")

		var camera_movement := Vector2(joy_camera_x_input, joy_camera_y_input)

		player.rotate_y(-camera_movement.x * y_sens)
		rotate_x(deg_to_rad(camera_movement.y * 1.2))
		rotation.x = clamp(rotation.x, deg_to_rad(look_down_deg), deg_to_rad(look_up_deg))
		rotation.z = clamp(rotation.z, 0, 0)
