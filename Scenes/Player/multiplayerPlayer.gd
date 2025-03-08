extends CharacterBody3D

var PlayerId

@export var CanMove : bool = true
@export var HasGravity : bool = true
@export var CanJump : bool = true
@export var CanSprint : bool = true
@export var CanFreefly : bool = true

@export_group("Speeds")
@export var LookSpeed : float = 0.002
@export var BaseSpeed : float = 7.0
@export var JumpVelocity : float = 4.5
@export var SprintSpeed : float = 10.0
@export var FreeflySpeed : float = 25.0

var LookRotation : Vector2
var MoveSpeed : float = 0.0
var IsFreeflying : bool = false

# Nodes
@onready var Collider: CollisionShape3D = $Collider

@export_group("Nodes")
@export var PlayerInput: MultiplayerSynchronizer
@export var CameraInput: Node3D

func _enter_tree() -> void:
	PlayerInput.set_multiplayer_authority(str(name).to_int())
	CameraInput.set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	var loadingScreen = get_tree().get_first_node_in_group("Loading")
	if loadingScreen:
		loadingScreen.visible = false
	else:
		printerr("Loading screen not found!")
	
	LookRotation.y = rotation.y
	LookRotation.x = CameraInput.rotation.x
	
	CameraInput.LookSpeed = LookSpeed

func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		applyMovementBasedOnInput(delta)

func applyMovementBasedOnInput(delta):
	if Input.is_action_just_pressed("pick_up"):
		pass
	
	# Freefly mode
	if CanFreefly and PlayerInput.IsFreeflying:
		if not IsFreeflying:
			enableFreefly()
		else:
			disableFreefly()
	
	# Freeflying Overwrite
	if CanFreefly and IsFreeflying:
		var inputDirection = PlayerInput.InputDirection
		var motion := (CameraInput.global_basis * Vector3(inputDirection.x, 0, inputDirection.y)).normalized()
		motion *= FreeflySpeed * delta
		
		if PlayerInput.IsMouseCaptured:
			transform.basis = Basis()
			var lookRotation = CameraInput.LookRotation
			rotate_y(CameraInput.LookRotation.y)
			CameraInput.transform.basis = Basis()
			CameraInput.rotate_x(CameraInput.LookRotation.x)
			
		move_and_collide(motion)
		return
	
	# Gravity
	if HasGravity:
		if not is_on_floor():
			velocity += get_gravity() * delta
	
	# Jumping
	if CanJump:
		if PlayerInput.IsJumping and is_on_floor():
			velocity.y = JumpVelocity
	
	# Sprinting
	if CanSprint and PlayerInput.IsSprinting:
			MoveSpeed = SprintSpeed
	else:
		MoveSpeed = BaseSpeed
	
	# Apply movement and velocity
	if CanMove:
		var inputDirection = PlayerInput.InputDirection
		var moveDirection := (transform.basis * Vector3(inputDirection.x, 0, inputDirection.y)).normalized()
		if moveDirection:
			velocity.x = moveDirection.x * MoveSpeed
			velocity.z = moveDirection.z * MoveSpeed
		else:
			velocity.x = move_toward(velocity.x, 0, MoveSpeed)
			velocity.z = move_toward(velocity.z, 0, MoveSpeed)
	else:
		velocity.x = 0
		velocity.y = 0
	
	if PlayerInput.IsMouseCaptured:
		transform.basis = Basis()
		var lookRotation = CameraInput.LookRotation
		rotate_y(CameraInput.LookRotation.y)
		CameraInput.transform.basis = Basis()
		CameraInput.rotate_x(CameraInput.LookRotation.x)
	
	move_and_slide()

## Rotation for looking around
func rotateLook(rotInput : Vector2):
	LookRotation.x -= rotInput.y * LookSpeed
	LookRotation.x = clamp(LookRotation.x, deg_to_rad(-85), deg_to_rad(85))
	LookRotation.y -= rotInput.x * LookSpeed
	transform.basis = Basis()
	rotate_y(LookRotation.y)
	CameraInput.transform.basis = Basis()
	CameraInput.rotate_x(LookRotation.x)

func enableFreefly():
	Collider.disabled = true
	IsFreeflying = true
	velocity = Vector3.ZERO

func disableFreefly():
	Collider.disabled = false
	IsFreeflying = false
