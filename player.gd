extends CharacterBody2D

var drag_factor := 0.15
var acceleration := 500.0
var decceleration := 222.0


func _ready() -> void:
	position = Vector2(640, 360)

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		if velocity.length() > 500:
			rotation -= 7 * 500/velocity.length() * delta
		else:
			rotation -= 7 * delta
	if Input.is_action_pressed("right"):
		if velocity.length() > 500:
			rotation += 7 * 500/velocity.length() * delta
		else:
			rotation += 7 * delta
		
	velocity -= velocity * drag_factor * delta   #atmospheric drag
	
	if Input.is_action_pressed("forwards"):
		velocity += Vector2.from_angle(rotation-(PI/2)) * acceleration * delta
	if Input.is_action_pressed("backwards"):
		if velocity.length() > 0.0:
			velocity -= velocity.normalized() * decceleration * delta
		
		

	move_and_slide()
