extends Area2D

@export var meteor_textures: Array[Texture2D]
var trajectory: Vector2
@export var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	var meteor_texture = meteor_textures[rng.randi_range(0, 19)]
	$MeteorSprite.texture = meteor_texture
	$CollisionMeteor.shape.radius = min(meteor_texture.get_height(), meteor_texture.get_width())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if trajectory != null:
		position += trajectory * speed * delta
