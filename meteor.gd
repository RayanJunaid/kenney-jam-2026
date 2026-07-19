extends Area2D

@export var meteor_textures: Array[Texture2D]
var trajectory: Vector2
@export var speed = 200
var max_health: int
var health: int
signal health_signal(health)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var meteor_texture = meteor_textures.pick_random()
	$MeteorSprite.texture = meteor_texture
	$CollisionMeteor.shape = $CollisionMeteor.shape.duplicate()
	$CollisionMeteor.shape.radius = max(meteor_texture.get_height(), meteor_texture.get_width())/2
	max_health = $CollisionMeteor.shape.radius
	health = max_health
	$HealthBar.value = int(100*health/max_health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if trajectory != null:
		position += trajectory * speed * delta

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		explode()
	$HealthBar.value = int(100*health/max_health)

func explode():
	health_signal.emit(max_health)
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
	explode()
