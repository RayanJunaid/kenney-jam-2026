extends Node2D

var background: Sprite2D
var camera: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = $Player/Camera 
	background = $Background 
	set_camera_limits($Player/Camera, background)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_camera_limits(camera: Camera2D, world: Sprite2D):
	var size:= world.get_rect().size
	camera.limit_left = world.global_position.x - size.x/2
	camera.limit_right = world.global_position.x + size.x/2
	camera.limit_top = world.global_position.y - size.y/2
	camera.limit_bottom = world.global_position.y + size.y/2
