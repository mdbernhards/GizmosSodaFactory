extends RigidBody3D

@onready var HandRemoteTransform: RemoteTransform3D = $HandRemoteTransform

var IsPicked: bool = false

func _input(event):
	if Input.is_action_just_pressed("pick_up"):
		if not IsPicked:
			pickUpBottle()
		else:
			dropBottle()

func pickUpBottle():
	# Set remote_path to the player's hand.
	# Adjust the path based on your scene structure.
	HandRemoteTransform.remote_path = get_tree().get_first_node_in_group("PlayerHand").get_path()
	IsPicked = true
	# Optionally, disable collision or physics on the bottle when picked up
	print("Bottle picked up!")

func dropBottle():
	# Clear remote_path so the bottle stops following the hand.
	HandRemoteTransform.remote_path = NodePath("")
	IsPicked = false
	# Optionally, re-enable collision or physics
	print("Bottle dropped!")
