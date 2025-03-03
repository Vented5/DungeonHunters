extends Node2D

@export var arrow_scene: PackedScene
var player

func _ready() -> void:
	player = get_parent()

func _process(delta: float) -> void:
	if Input.is_action_pressed("attack"):
		$Sprite2D.rotation = player.direction.angle() - deg_to_rad(235)
	if Input.is_action_just_released("attack"):
		shoot()

func shoot():
	var arrow = arrow_scene.instantiate()
	arrow.rotation = player.direction.angle()
	add_child(arrow)
	print("Arrow shooted")
