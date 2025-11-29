extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deactivate_feature()


func activate_feature():
	position.x -= 3000
	
func deactivate_feature():
	position.x += 3000
