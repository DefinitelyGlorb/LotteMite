extends Node3D

signal health_depleted

@export_group("Player Settings")
@export var sensitivity = 0.3

@export_group("Player Stats")
@export var max_health = 3.0
@export var health = max_health

func _ready() -> void:
	%HealthBar.max_value = max_health
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta: float) -> void:
	const SPEED = 5.5
	const JUMP_VELOCITY = 10.0
	const FALL_VELOCITY = 20.0
	
	var input_direction_2D = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")	
	var input_direction_3D = Vector3(input_direction_2D.x, 0, input_direction_2D.y)
	
	var direction = %CameraPivot.global_basis * -input_direction_3D
	
	$PlayerBody.velocity.x = direction.x * SPEED
	%PlayerBody.velocity.y -= FALL_VELOCITY * delta
	$PlayerBody.velocity.z = direction.z * SPEED
	
	if Input.is_action_just_pressed("jump") and %PlayerBody.is_on_floor():
		%PlayerBody.velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_released("jump") and %PlayerBody.velocity.y > 0:
			%PlayerBody.velocity.y = lerp($PlayerBody.velocity.y, 0.0, 0.75)
		
	%PlayerBody.move_and_slide()
	
func _process(_delta: float) -> void:
	%HealthBar.value = health
	if health <= 0:
		health_depleted.emit()
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		%CameraPivot.rotation_degrees.y -= event.relative.x * sensitivity
		%CameraPivot.rotation_degrees.x += event.relative.y * sensitivity
		%CameraPivot.rotation_degrees.x = clamp(%CameraPivot.rotation_degrees.x, -30.0, 60.0)
