extends Node2D

var speed = 200
var rotation_speed = 0.02
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * speed * delta
	$Sprite2D.rotation -= rotation_speed

func _on_area_entered(area: Area2D) -> void:
	scale.x = 1.5
	scale.y = 1.5
	speed = 50
	rotation_speed = 0.005
	await get_tree().create_timer(2).timeout
	queue_free()
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
