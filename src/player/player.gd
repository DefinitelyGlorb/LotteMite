extends CharacterBody3D

signal health_depleted

var health = PlayerStats.max_health
var hovering = false

func _ready() -> void:
	%HealthBar.max_value = PlayerStats.max_health
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta: float) -> void:
	const SPEED = 8.0
	const JUMP_VELOCITY = 10.0
	const FALL_VELOCITY = 30.0
	
	var input_direction_2D = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")	
	var input_direction_3D = Vector3(input_direction_2D.x, 0, input_direction_2D.y)
	
	var direction = %CameraPivot.global_basis * -input_direction_3D
	
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_released("jump") and velocity.y > 0:
		velocity.y = lerp(velocity.y, 0.0, 0.75)
	
	if Input.is_action_just_pressed("jump") and not %RayCast3D.is_colliding() and not is_on_floor():
		hovering = true
	elif is_on_floor() or Input.is_action_just_released("jump"):
		hovering = false
			
	if hovering:
		velocity.y = lerp(velocity.y, -2.5, 0.25)	
	else:
		velocity.y -= lerp(0.0, FALL_VELOCITY, 0.75) * delta
	
	move_and_slide()
	
func _process(_delta: float) -> void:
	%HealthBar.value = health
	if health <= 0:
		health_depleted.emit()
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		%CameraPivot.rotation_degrees.y -= event.relative.x * PlayerSettings.sensitivity
		%CameraPivot.rotation_degrees.x += event.relative.y * PlayerSettings.sensitivity
		%CameraPivot.rotation_degrees.x = clamp(%CameraPivot.rotation_degrees.x, -30.0, 60.0)
		
func take_damage() -> void:
	health -= 1	

func _on_hurtbox_body_entered(body: Node3D) -> void:
	if body.has_method("attack"):
		take_damage()
	 
