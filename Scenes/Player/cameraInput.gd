extends Node3D

@export var Camera: Camera3D

var LookSpeed : float = 0.002
@export var LookRotation : Vector2 = Vector2.ZERO

func _ready() -> void:
	if multiplayer.get_unique_id() == str(get_parent().name).to_int():
		Camera.current = true
	else:
		Camera.current = false
		
	LookRotation.y = rotation.y
	LookRotation.x = rotation.x

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotateCamera(event.relative)
		
func rotateCamera(rotInput : Vector2):
	#print(rotInput)
	LookRotation.x -= rotInput.y * LookSpeed
	LookRotation.x = clamp(LookRotation.x, deg_to_rad(-85), deg_to_rad(85))
	LookRotation.y -= rotInput.x * LookSpeed
