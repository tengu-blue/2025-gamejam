extends Sprite2D


@export var distance : Vector2
@export var moveTime : float = 0.2


var state : bool = false

var going : bool = true

@export var initPos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initPos = position



func toggle():
	var t = create_tween()
	if(state):
		t.tween_property($".", "position", initPos+distance, moveTime)
	else:
		t.tween_property($".", "position", initPos, moveTime)
	t.play()
	
func _on_timer_timeout() -> void:
	state = !state
	toggle()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.hit()
