extends Button


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Blank.tscn")
	GameManager.BeginGame()

# also if press B on controller

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Next"):
		_on_pressed()
