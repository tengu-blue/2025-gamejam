extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player enter")
		body.can_wall_jump()
		


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player exit")
		body.cannot_wall_jump()
		
