extends Sprite2D

# Todo: when player reaches -> call level done
# pause and then reset probably

var initPos : Vector2

func  _ready() -> void:
	initPos = position

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		GameManager.level_beaten()
		

var state := false

func _on_timer_timeout() -> void:
	
	if(state):
		create_tween().tween_property($".", "position", initPos + Vector2(0, 5), 1)
	else:
		create_tween().tween_property($".", "position", initPos, 1)
		
	state = !state
	
