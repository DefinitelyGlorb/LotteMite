extends RigidBody3D

const SPEED = 3.0

@onready var player = get_node("../../Player")

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	direction.y = 0.0
	linear_velocity = direction * SPEED
	pass
	
func attack() -> void:
	pass
