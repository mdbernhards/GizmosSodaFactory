extends Node3D

@export var PumpId = 0
var IsPumpOn = false

# Nodes
var Construction
var BuildButton
var OnButton
var OffButton
var PumpActivityLabel
var StartTimer
var PumpTimer

func _ready() -> void:
	setupNodePaths()
	Construction.visible = false
	OnButton.visible = false
	OffButton.visible = false

func setupNodePaths():
	Construction = $Construction
	BuildButton = $Buttons/BuildButton
	OnButton = $Buttons/OnButton
	OffButton = $Buttons/OffButton
	PumpActivityLabel = $Construction/Construction/PumpActivityLabel
	StartTimer = $Timers/StartTimer
	PumpTimer = $Timers/PumpTimer

func _on_build_button_collision_body_entered(body: Node3D) -> void:
	BuildButton.visible = false
	Construction.visible = true
	OnButton.visible = true
	OffButton.visible = true

func _on_on_button_collision_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		IsPumpOn = true
		PumpActivityLabel.text = "ON"
		StartTimer.start()

func _on_off_button_collision_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		IsPumpOn = false
		PumpActivityLabel.text = "OFF"
		StartTimer.stop()
		PumpTimer.stop()

func _on_start_timer_timeout() -> void:
	if IsPumpOn:
		PumpTimer.start()

func _on_pump_timer_timeout() -> void:
	if IsPumpOn:
		var waterTank = get_tree().get_first_node_in_group("WaterTank")
		
		if waterTank.WaterTankId == 1:
			waterTank.WaterLevel += 2
			PumpTimer.start()
