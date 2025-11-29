extends Node2D


# has the player, does everything gameplay-wise
# know when to use input and when to ignore etc.


# Will toggle the separate layers 
func show_layer(layer) -> void:
	
	match layer:
		"spikes":
			$SpikesLayers.activate_feature()
			$MovingSpikes.activate_feature()
		"pits":
			$Pits.activate_feature()
		"platforms":
			$Platforms.activate_feature()
		"pikes":
			$Pikes.activate_feature()
		"sawblade":
			$Sawblade.activate_feature()
		"hardest":
			$Hardest/MoreMovingSpikes.activate_feature()
			$Hardest/MorePikes.activate_feature()
			$MorePlatforms.activate_feature()
	
	$PlayerController.hit()
	

# TODO: unload this level and load blank again
func end_all() -> void:
	SceneTransitioner.transition(func():
		get_tree().change_scene_to_file("res://scenes/Blank.tscn")
	)
