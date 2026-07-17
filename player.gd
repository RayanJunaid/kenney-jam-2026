extends CharacterBody2D


const MAX_SPEED = 300.0
const ACCELERATION = 600.0
const DECELERATION = 300.0
const ROTATION_SPEED = PI


func _physics_process(delta: float) -> void:

	# Get left/right inputs and handle the rotation.
	var rotation_direction := Input.get_axis("left", "right")
	rotation += rotation_direction * ROTATION_SPEED * delta
	
	# Get up/down inputs and handle acceleration.
	var move_direction := Input.get_axis("backwards", "forwards")
	
	# TO-DO: implement acceleration and velocity based on the direction the ship is facing and make it feel similar to the dpr bored game.
	# BELOW IS TEMPORARY CODE TO TEST CAMERA, DELETE WHEN MAKING ACTUAL MOVEMENT CODE
	if Input.is_action_pressed("forwards"): 
		velocity = velocity.move_toward(Vector2.from_angle(rotation) * move_direction * MAX_SPEED, ACCELERATION*delta)
	
	move_and_slide()
