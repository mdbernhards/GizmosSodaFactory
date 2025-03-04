extends MultiplayerSynchronizer

@export var InputDirection = Vector2.ZERO
@export var IsJumping = false
@export var IsSprinting = false
@export var IsFreeflying = false
@export var MouseRelativeRoatation = Vector2.ZERO
@export var IsMouseCaptured = false

#region Input Actions
var InputLeft : String = "ui_left"
var InputRight : String = "ui_right"
var InputForward : String = "ui_up"
var InputBack : String = "ui_down"
var InputJump : String = "ui_accept"
var InputSprint : String = "sprint"
var InputFreefly : String = "freefly"
#endregion

func _ready() -> void:
	#if get_multiplayer_authority() != multiplayer.get_unique_id():
	#	set_process(false)
	#	set_physics_process(false)
	pass

func _physics_process(delta: float) -> void:
	InputDirection = Input.get_vector(InputLeft, InputRight, InputForward, InputBack)
	IsJumping = Input.is_action_just_pressed(InputJump)
	IsSprinting = Input.is_action_pressed(InputSprint)
	if InputDirection:
		print(InputDirection)

func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	# Freefly mode
	IsFreeflying = Input.is_action_just_pressed(InputFreefly)
	
	# Mouse
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		captureMouse()
	if Input.is_key_pressed(KEY_ESCAPE):
		releaseMouse()

func captureMouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	IsMouseCaptured = true

func releaseMouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	IsMouseCaptured = false
