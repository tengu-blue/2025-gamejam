extends Label


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	
	if event is InputEventMouseButton and event.pressed:
		# forward to the next dialog
		GameManager.dialog_next()
