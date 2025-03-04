extends CharacterBody3D

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

@export_group("Input Actions")
@export var InputLeft : String = "ui_left"
@export var InputRight : String = "ui_right"
@export var InputForward : String = "ui_up"
@export var InputBack : String = "ui_down"
@export var InputJump : String = "ui_accept"
@export var InputSprint : String = "sprint"
@export var InputFreefly : String = "freefly"

var MouseCaptured : bool = false
var LookRotation : Vector2
var MoveSpeed : float = 0.0
var IsFreeflying : bool = false

# Nodes
@onready var Head: Node3D = $Head
@onready var Collider: CollisionShape3D = $Collider

func _ready() -> void:
	checkInputMappings()
	LookRotation.y = rotation.y
	LookRotation.x = Head.rotation.x

func _physics_process(delta: float) -> void:
	# Freeflying Overwrite
	if CanFreefly and IsFreeflying:
		var inputDirection := Input.get_vector(InputLeft, InputRight, InputForward, InputBack)
		var motion := (Head.global_basis * Vector3(inputDirection.x, 0, inputDirection.y)).normalized()
		motion *= FreeflySpeed * delta
		move_and_collide(motion)
		return
	
	# Gravity
	if HasGravity:
		if not is_on_floor():
			velocity += get_gravity() * delta
	
	# Jumping
	if CanJump:
		if Input.is_action_just_pressed(InputJump) and is_on_floor():
			velocity.y = JumpVelocity
	
	# Sprinting
	if CanSprint and Input.is_action_pressed(InputSprint):
			MoveSpeed = SprintSpeed
	else:
		MoveSpeed = BaseSpeed
	
	# Apply movement and velocity
	if CanMove:
		var inputDirection := Input.get_vector(InputLeft, InputRight, InputForward, InputBack)
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
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	# Mouse
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		captureMouse()
	if Input.is_key_pressed(KEY_ESCAPE):
		releaseMouse()
	
	# Look around
	if MouseCaptured and event is InputEventMouseMotion:
		rotateLook(event.relative)
	
	# Freefly mode
	if CanFreefly and Input.is_action_just_pressed(InputFreefly):
		if not IsFreeflying:
			enableFreefly()
		else:
			disableFreefly()

func captureMouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	MouseCaptured = true

func releaseMouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	MouseCaptured = false

## Rotation for looking around
func rotateLook(rotInput : Vector2):
	LookRotation.x -= rotInput.y * LookSpeed
	LookRotation.x = clamp(LookRotation.x, deg_to_rad(-85), deg_to_rad(85))
	LookRotation.y -= rotInput.x * LookSpeed
	transform.basis = Basis()
	rotate_y(LookRotation.y)
	Head.transform.basis = Basis()
	Head.rotate_x(LookRotation.x)

func enableFreefly():
	Collider.disabled = true
	IsFreeflying = true
	velocity = Vector3.ZERO

func disableFreefly():
	Collider.disabled = false
	IsFreeflying = false

## Disables functionality if it isn't mapped
func checkInputMappings():
	if CanMove and not InputMap.has_action(InputLeft):
		push_error("Movement disabled. No InputAction found for input_left: " + InputLeft)
		CanMove = false
	if CanMove and not InputMap.has_action(InputRight):
		push_error("Movement disabled. No InputAction found for input_right: " + InputRight)
		CanMove = false
	if CanMove and not InputMap.has_action(InputForward):
		push_error("Movement disabled. No InputAction found for input_forward: " + InputForward)
		CanMove = false
	if CanMove and not InputMap.has_action(InputBack):
		push_error("Movement disabled. No InputAction found for input_back: " + InputBack)
		CanMove = false
	if CanJump and not InputMap.has_action(InputJump):
		push_error("Jumping disabled. No InputAction found for input_jump: " + InputJump)
		CanJump = false
	if CanSprint and not InputMap.has_action(InputSprint):
		push_error("Sprinting disabled. No InputAction found for input_sprint: " + InputSprint)
		CanSprint = false
	if CanFreefly and not InputMap.has_action(InputFreefly):
		push_error("Freefly disabled. No InputAction found for input_freefly: " + InputFreefly)
		CanFreefly = false
