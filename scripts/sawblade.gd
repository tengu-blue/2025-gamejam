extends Sprite2D


# TODO: move from specified locations back anf forth with given speed 
# TODO: rotate

@export var speed : float = 5
@export var moveTime : float = 0.5

var state : bool = false

var going : bool = true

@export var initPos : Vector2

@export var position1 : Vector2
@export var position2 : Vector2

func _ready() -> void:
	initPos = position
	deactivate_feature()

func _process(delta: float) -> void:
	rotate(delta * speed)
	

func activate_feature():
	position.x -= 1000
	going = true
	
func deactivate_feature():
	position.x += 1000
	going = false


func toggle():
	var t = create_tween()
	if(state):
		t.tween_property($".", "position", initPos+position2, moveTime)
	else:
		t.tween_property($".", "position", initPos+position1, moveTime)
	t.play()
	
func _on_timer_timeout() -> void:
	state = !state
	if (going):
		toggle()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.hit()
