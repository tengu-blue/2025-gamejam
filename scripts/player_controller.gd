extends CharacterBody2D

var initCol : Color 

func _ready() -> void:
	position = $"../Spawn".position
	initCol = $Sprite2D.modulate

func death_anim() -> void:
	
	var t = create_tween()
	t.tween_property($Sprite2D, "modulate", Color.DARK_RED, 0.1)
	t.tween_property($Sprite2D, "scale", Vector2(0, 0), 0.1)
	t.set_parallel()
	
	velocity.x = 0
	velocity.y = 0
	jumping = false
	on_wall = false
	jumpCounter = 0
	
	await t.finished
	
	position = $"../Spawn".position
		
	$Sprite2D.modulate = initCol
	$Sprite2D.scale = Vector2(1, 1)
	
	GameManager.respawned()


@export var gravityScale : float = 1
@export var accel : float = 1
@export var maxSpeed : float = 3
@export var initAccel : float = 0.4
@export var airSpeed : float = 1
@export var maxUpSpeed : float = 10
@export var jumpStr : float = 10

@export var damp : float = 0.5
@export var jumpDamp : float = 0.5

@export var coyote_time : float = 0.1

@export var jumpTime : float = 5
var jumping : bool = false
var jumpCounter : float = 0

var last_ground : float = 0

var wall_dir_left : bool = false
var on_wall : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var action := false
	
	if(!jumping):
		jumpCounter = 0
	
	# input
	if GameManager.can_move() and Input.is_action_pressed("Left"):
		if(velocity.x > 0):
			velocity.x *= damp * damp
			
		if !is_on_floor():
			velocity.x -= airSpeed * delta
		else:			
			# less at start		
			if(velocity.x*velocity.x < 0.1):
				velocity.x -= accel * delta * initAccel
			else:
				velocity.x -= accel * delta
			
		action = true
		
	if GameManager.can_move() and Input.is_action_pressed("Right"):
		if(velocity.x < 0):
			velocity.x *= damp * damp
					
		
		if !is_on_floor():
			velocity.x += airSpeed * delta
		else:	
			# less at start		
			if(velocity.x*velocity.x < 0.1):
				velocity.x += accel * delta * initAccel
			else:
				velocity.x += accel * delta
		
		action = true
	
	# speed falloff
	if(!action):
		velocity.x *= damp
	if(velocity.x*velocity.x < 0.001):
		velocity.x = 0
	
	# max speed
	if(velocity.x*velocity.x > maxSpeed*maxSpeed):
		velocity.x = maxSpeed if velocity.x > 0 else -maxSpeed
	
	
	if GameManager.can_move() and Input.is_action_just_pressed("Jump") and (is_on_floor() or on_wall or Time.get_ticks_msec() - last_ground < coyote_time*1000) and !jumping:
		jumping = true
		$SFXPlayerJump.play()
		last_ground -= 1000
	
	if jumping:
		jumpCounter += delta
		
		if(on_wall):
			velocity.y -= jumpStr * 0.85
			if(wall_dir_left):
				velocity.x += airSpeed * 20 * delta
			else:
				velocity.x -= airSpeed * 20 * delta
		else:
			velocity.y -= jumpStr
			
		if(jumpCounter > jumpTime):
			jumping = false
		
	if Input.is_action_just_released("Jump") and !is_on_floor() and velocity.y < 0:
		jumping = false
		velocity.y *= jumpDamp
	
	
	# coyote
	if Time.get_ticks_msec() - last_ground >= coyote_time*1000:
		# gravity
		if !on_wall or (!jumping and velocity.y < 0):
			velocity += delta * get_gravity() * gravityScale
		else:
			# slide ?
			velocity += delta * get_gravity() * gravityScale * 0.1
	

func can_wall_jump(left : bool):
	on_wall = true
	jumping = false
	jumpCounter = 0
	wall_dir_left = left
	
func cannot_wall_jump():
	on_wall = false

func _physics_process(_delta) -> void:
	move_and_slide()
	
	if is_on_floor():
		last_ground = Time.get_ticks_msec()
		jumping = false
		
# -------------------------------------------------------

func hit():
	$SFXPlayerHit.play()
	death_anim()
