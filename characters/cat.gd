extends Player

@export var arrow_scene: PackedScene = load("res://weapons/arrow.tscn")

func _ready():
	speed = 600
	super.init_health()
	super._ready()

func _process(_delta: float): 
	super._process(_delta)
	
	if Input.is_action_just_pressed("attack") and is_attacking==0:
		handle_attack(direction.angle())

func handle_attack(angle):
	is_attacking = 1
	$Animation.play("attack")
	await get_tree().create_timer(0.6).timeout
	$AudioStreamPlayer.play()
	shoot(angle)
	
	await $Animation.animation_finished
	#await get_tree().create_timer(1.6).timeout
	$Animation.stop()
	is_attacking = 0
	$Animation.offset = Vector2.ZERO
	

@rpc("call_local", "unreliable")
func shoot(angle):
	var arrow = arrow_scene.instantiate()
	$Marker2D.rotation = angle
	arrow.transform = $Marker2D.global_transform
	get_parent().get_parent().add_child(arrow)


func _on_hitbox_area_entered(area: Area2D) -> void:
	super.get_hit(area)
