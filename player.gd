extends CharacterBody2D

var drag_factor := 0.15
var acceleration := 500.0
var decceleration := 222.0
var level: Node2D = null
var health := 3
var invincible := false
signal laser(pos)

func _ready() -> void:
	position = Vector2(640, 360)

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		laser.emit($LaserSpawnPoint.global_position)
	
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
		
	if level != null:
		if global_position.x <= level.world_border_left or global_position.x >= level.world_border_right:
			velocity.x = 0
		if global_position.y <= level.world_border_top or global_position.y >= level.world_border_bottom:
			velocity.y = 0
		global_position.x = clamp(global_position.x, level.world_border_left, level.world_border_right)
		global_position.y = clamp(global_position.y, level.world_border_top, level.world_border_bottom)


func take_damage():
	health -= 1
	if health <= 0:
		print("dead")
	$CollisionFront.set_deferred("disabled", true)
	$CollisionBack.set_deferred("disabled", true)
	$InvincibilityTimer.start()
	invincible = true
	blink_effect()


func _on_invincibility_timer_timeout() -> void:
	invincible = false
	$CollisionFront.set_deferred("disabled", false)
	$CollisionBack.set_deferred("disabled", false)


func blink_effect():
	while invincible:
		$PlayerImage.visible = !$PlayerImage.visible
		await get_tree().create_timer(0.1).timeout
	$PlayerImage.visible = true
