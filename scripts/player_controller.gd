extends CharacterBody2D


@export var gravityScale : float = 1
@export var accel : float = 1
@export var maxSpeed : float = 3
@export var initAccel : float = 0.4
@export var airSpeed : float = 1
@export var maxUpSpeed : float = 10
@export var jumpStr : float = 10

@export var damp : float = 0.5
@export var jumpDamp : float = 0.5

@export var jumpTime : float = 5
var jumping : bool = false
var jumpCounter : float = 0

var on_wall : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var action := false
	
	if(!jumping):
		jumpCounter = 0
	
	# input
	if Input.is_action_pressed("Left"):
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
		
	if Input.is_action_pressed("Right"):
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
	
	
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or on_wall) and !jumping:
		jumping = true
	
	if jumping:
		jumpCounter += delta
		
		if(on_wall):
			velocity.y -= jumpStr * 0.85
		else:
			velocity.y -= jumpStr
			
		if(jumpCounter > jumpTime):
			jumping = false
		
	if Input.is_action_just_released("Jump") and !is_on_floor() and velocity.y < 0:
		jumping = false
		velocity.y *= jumpDamp
	
	
	# gravity
	if !on_wall or (!jumping and velocity.y < 0):
		velocity += delta * get_gravity() * gravityScale
	else:
		# slide ?
		velocity += delta * get_gravity() * gravityScale * 0.1
	

func can_wall_jump():
	on_wall = true
	jumping = false
	jumpCounter = 0
	
func cannot_wall_jump():
	on_wall = false

func _physics_process(_delta) -> void:
	move_and_slide()
	
	if is_on_floor():
		jumping = false
