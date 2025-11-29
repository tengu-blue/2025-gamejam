extends Node2D

var initPos : Vector2
var timer : Timer

@export var dir := Vector2(0, 1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initPos = position
	timer = Timer.new()
	timer.autostart = true
	timer.timeout.connect(time)
	add_child(timer)

var state := false
func time() -> void:
	state = !state
	
	if(state):
		create_tween().tween_property(self, "position", initPos + dir, 1)
	else:
		create_tween().tween_property(self, "position", initPos, 1)
	
