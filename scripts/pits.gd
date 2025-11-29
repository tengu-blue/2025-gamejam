extends TileMapLayer


func activate_feature():
	position.x -= 1000
	
func deactivate_feature():
	position.x += 1000
