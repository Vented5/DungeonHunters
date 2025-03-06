extends Node2D

@export var arrow_scene: PackedScene = load("res://weapons/arrow.tscn")
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
	arrow.transform = $Marker2D.global_transform
	arrow.rotation = player.direction.angle()
	get_parent().get_parent().add_child(arrow)
	print("Arrow shooted, parent:", get_parent().get_parent())
