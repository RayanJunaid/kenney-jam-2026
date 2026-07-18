extends Node2D

var speed := 0
var drag := 10
var acceleration := 150
var decceleration := 222


func _ready() -> void:
	position = Vector2(640, 360)

func _process(delta: float) -> void:
	
	if speed > 1000:
		speed = 1000

	if Input.is_action_pressed("forwards"):
		@warning_ignore("narrowing_conversion")
		speed += acceleration * delta
	elif Input.is_action_pressed("backwards"):
		if speed > 0:
			@warning_ignore("narrowing_conversion")
			speed -= decceleration * delta
	elif speed > drag:
		@warning_ignore("narrowing_conversion")
		speed -= drag * delta 
		
		
	if Input.is_action_pressed("left"):
		if speed > 500:
			@warning_ignore("integer_division")
			rotation -= 7 * 500/speed * delta
		else:
			rotation -= 7 * delta
	if Input.is_action_pressed("right"):
		if speed > 500:
			@warning_ignore("integer_division")
			rotation += 7 * 500/speed * delta
		else:
			rotation += 7 * delta
		
	position += Vector2((speed) * sin(rotation) * delta,(-speed) * cos(rotation) * delta)
