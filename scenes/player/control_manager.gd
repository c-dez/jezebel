extends Node

# STATE MACHINE CON ESTADOS DEPENDIENDO DE EL INPUT QUE EL JUGADOR USA, MOUSE O GAMEPAD
enum CONTROLLER_TYPE {MOUSE, GAMEPAD}
var control_type: int = CONTROLLER_TYPE.MOUSE


func _physics_process(_delta) -> void:
	# _process(delta)?
	detect_control_type()
	

func detect_control_type() -> void:
	if Input.is_action_just_pressed("mouse_1") or Input.is_action_just_pressed("move_jump") and !control_type == CONTROLLER_TYPE.MOUSE:
		control_type = CONTROLLER_TYPE.MOUSE
	if Input.is_action_just_pressed("joy_l_trigger") or Input.is_action_just_pressed("joy_r_trigger") and !control_type == CONTROLLER_TYPE.GAMEPAD:
		control_type = CONTROLLER_TYPE.GAMEPAD
