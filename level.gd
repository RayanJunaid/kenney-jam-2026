extends Node2D

var background: Sprite2D
var player: CharacterBody2D
var camera: Camera2D
var score: int
var world_size: Vector2
var world_border_left: float
var world_border_right: float
var world_border_top: float
var world_border_bottom: float
var laser_scene: PackedScene = load("res://Laser.tscn")
var meteor_scene: PackedScene = load("res://Meteor.tscn")
var meteor_spawn_buffer := 100.0
var can_shoot := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $Player
	score = 0
	camera = $Player/Camera 
	background = $Background 
	world_size = $Background.get_rect().size
	
	# world borders
	world_border_left = background.global_position.x - world_size.x/2
	world_border_right = background.global_position.x + world_size.x/2
	world_border_top = background.global_position.y - world_size.y/2
	world_border_bottom = background.global_position.y + world_size.y/2
	
	set_camera_limits(world_border_left, world_border_right, world_border_top, world_border_bottom)
	player.level = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		
	# despawn meteors
	for meteor in $Meteors.get_children():
		if (meteor.global_position.x < world_border_left - meteor_spawn_buffer or
			meteor.global_position.x > world_border_right + meteor_spawn_buffer or
			meteor.global_position.y < world_border_top - meteor_spawn_buffer or
			meteor.global_position.y > world_border_bottom + meteor_spawn_buffer):
				meteor.queue_free()
	
	# despawn lasers
	for laser in $Lasers.get_children():
		if (laser.global_position.x < world_border_left - meteor_spawn_buffer or
			laser.global_position.x > world_border_right + meteor_spawn_buffer or
			laser.global_position.y < world_border_top - meteor_spawn_buffer or
			laser.global_position.y > world_border_bottom + meteor_spawn_buffer):
				laser.queue_free()
	
	$HUD/Score.text = "Score: " + str(score)


func set_camera_limits(left: float, right: float, top: float, bottom: float):
	@warning_ignore("narrowing_conversion")
	camera.limit_left = left
	@warning_ignore("narrowing_conversion")
	camera.limit_right = right
	@warning_ignore("narrowing_conversion")
	camera.limit_top = top
	@warning_ignore("narrowing_conversion")
	camera.limit_bottom = bottom


func _on_player_laser(pos: Variant) -> void:
	if can_shoot == true:
		can_shoot = false
		var laser = laser_scene.instantiate()
		laser.global_position = pos
		laser.rotation = $Player.rotation
		$Lasers.add_child(laser)
		$LaserTimer.start()


func _on_meteor_timer_timeout() -> void:
	var camera_size = get_viewport_rect().size / camera.zoom
	var camera_centre = camera.get_screen_center_position()
	var edge = randi() % 4
	var spawn_pos: Vector2
	
	# randomise spawn position
	if edge == 0: #left edge
		spawn_pos = Vector2(camera_centre.x - (camera_size.x / 2) - meteor_spawn_buffer, randf_range(camera_centre.y - (camera_size.y / 2), camera_centre.y + (camera_size.y / 2)))
	if edge == 1: #right edge
		spawn_pos = Vector2(camera_centre.x + (camera_size.x / 2) + meteor_spawn_buffer, randf_range(camera_centre.y - (camera_size.y / 2), camera_centre.y + (camera_size.y / 2)))
	if edge == 2: #top edge
		spawn_pos = Vector2(randf_range(camera_centre.x - (camera_size.x / 2), camera_centre.x + (camera_size.x / 2)), camera_centre.y - (camera_size.y / 2) - meteor_spawn_buffer)
	if edge == 3: #right edge
		spawn_pos = Vector2(randf_range(camera_centre.x - (camera_size.x / 2), camera_centre.x + (camera_size.x / 2)), camera_centre.y + (camera_size.y / 2) + meteor_spawn_buffer)
		

	var meteor = meteor_scene.instantiate()
	meteor.health_signal.connect(_on_health_signal)
	var trajectory = spawn_pos.direction_to(camera.global_position)
	trajectory = trajectory.rotated(randf_range(-0.5, 0.5))
	meteor.global_position = spawn_pos
	meteor.trajectory = trajectory
	$Meteors.add_child(meteor)


func _on_health_signal(health: Variant) -> void:
	score += health


func _on_laser_timer_timeout() -> void:
	can_shoot = true
