extends TileMapLayer


func _ready() -> void:
	deactivate_feature()



func activate_feature():
	position.x -= 1000
	
func deactivate_feature():
	position.x += 1000
