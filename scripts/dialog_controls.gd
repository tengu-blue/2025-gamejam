extends Label


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	
	if event is InputEventMouseButton and event.pressed:
		# forward to the next dialog
		GameManager.dialog_next()

func _process(delta: float) -> void:
	
	if $"..".visible and Input.is_action_just_pressed("Next"):
		GameManager.dialog_next()
		


func _on_visibility_changed() -> void:
	modulate.a = 0
	create_tween().tween_property(self, "modulate:a", 1, 0.5)
