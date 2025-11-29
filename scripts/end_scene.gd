extends CanvasLayer


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		# forward to the next dialog
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")


func _process(delta: float) -> void:
	
	if visible and Input.is_action_just_pressed("Next"):
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
