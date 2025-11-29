extends TileMapLayer


# down vs up
var state := true

@export var offset : int = 64

var initPos : Vector2

func _ready() -> void:
	initPos = position
	deactivate_feature()

func activate_feature():
	position.x -= 1000
	
func deactivate_feature():
	position.x += 1000

# TODO: animation
func toggle():
	
	var t = create_tween()
	t.tween_property($".", "position", initPos-offset*Vector2.UP, 0.2)
	
	await t.finished
	
	t = create_tween()
	t.tween_property($".", "position", initPos, 0.2)	

func _on_timer_timeout() -> void:
	toggle()
