extends VehicleBody3D

# Adjustable parameters for your car
@export var engine_power: float = 1500.0
@export var brake_power: float = 2000.0
@export var max_steering_angle: float = 0.4

func _physics_process(delta: float) -> void:
	var engine_force = 0.0
	# Handle acceleration and braking input
	if Input.is_action_pressed("accelerate"):
		engine_force += engine_power
	if Input.is_action_pressed("brake"):
		engine_force -= brake_power

	var steer_angle = 0.0
	# Handle steering input
	if Input.is_action_pressed("steer_left"):
		steer_angle = max_steering_angle
	elif Input.is_action_pressed("steer_right"):
		steer_angle = -max_steering_angle

	# Apply forces to the wheels
	for wheel in get_children():
		if wheel is VehicleWheel3D:
			# Set steering on front wheels
			if wheel.name == "WheelFrontLeft" or wheel.name == "WheelFrontRight":
				wheel.steering = steer_angle
			else:
				wheel.steering = 0.0
			# For a rear-wheel drive setup, apply engine force to rear wheels
			if wheel.name == "WheelRearLeft" or wheel.name == "WheelRearRight":
				wheel.engine_force = engine_force
			else:
				wheel.engine_force = 0.0
