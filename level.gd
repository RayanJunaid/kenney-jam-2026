extends Node2D

var background: Sprite2D
var camera: Camera2D
var world_size: Vector2
var world_border_left: float
var world_border_right: float
var world_border_top: float
var world_border_bottom: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = $Player/Camera 
	background = $Background 
	world_size = $Background.get_rect().size
	
	# world borders
	world_border_left = background.global_position.x - world_size.x/2
	world_border_right = background.global_position.x + world_size.x/2
	world_border_top = background.global_position.y - world_size.y/2
	world_border_bottom = background.global_position.y + world_size.y/2
	
	set_camera_limits(camera, world_border_left, world_border_right, world_border_top, world_border_bottom)
	$Player.level = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_camera_limits(camera: Camera2D, left: float, right: float, top: float, bottom: float):
	camera.limit_left = left
	camera.limit_right = right
	camera.limit_top = top
	camera.limit_bottom = bottom
