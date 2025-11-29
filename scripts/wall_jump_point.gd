extends Area2D

@export var left := false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.can_wall_jump(left)
		


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.cannot_wall_jump()
		
