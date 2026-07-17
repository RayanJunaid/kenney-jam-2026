extends Node2D

var world_size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	world_size = $Background.region_rect.size # Store world size Vector2 using Background size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
