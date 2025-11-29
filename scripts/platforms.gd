extends TileMapLayer

# down vs up
var state := true
var toggling := false

@export var offset : int = 1500


func _ready() -> void:
	deactivate_feature()

func activate_feature():
	toggling = true
	
func deactivate_feature():
	toggling = false

# TODO: animation
func toggle():
	if(state):
		position.x += offset
	else:
		position.x -= offset


func _on_timer_timeout() -> void:
	state = !state
	
	if toggling:
		toggle()
