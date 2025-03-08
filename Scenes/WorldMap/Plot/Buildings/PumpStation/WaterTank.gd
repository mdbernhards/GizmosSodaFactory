extends CSGCylinder3D

# Nodes
var WaterLevelInTank

@export var WaterTankId = 0

var WaterLevel = 0:
	set(waterLevel):
		WaterLevel = waterLevel
		setWaterLevel(waterLevel)

func _ready() -> void:
	setupNodePaths()

func setWaterLevel(waterLevel):
	WaterLevelInTank.height = remap(waterLevel, 0, 100, 0, 5.5)

func setupNodePaths():
	WaterLevelInTank = $WaterLevelInTank
