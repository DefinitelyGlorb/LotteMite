extends Node3D
@export_group("Camera")
@export var rotation_speed = 0.3
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event: InputEvent) -> void:
	pass
		
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$CameraPivot.rotation_degrees.y -= event.relative.x * rotation_speed
		$CameraPivot.rotation_degrees.x -= event.relative.y * rotation_speed
		$CameraPivot.rotation_degrees.x = clamp($CameraPivot.rotation_degrees.x, -30.0, 60.0)
