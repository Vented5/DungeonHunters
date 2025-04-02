extends Player

func _ready():
	speed = 500
	super.init_health()
	super._ready()

func _process(_delta: float): 
	super._process(_delta)
	
	if Input.is_action_just_pressed("attack") and is_attacking==0:
		handle_attack()

func handle_attack():
	is_attacking = 1
	if $Animation.flip_h: 
		$Animation.offset = Vector2(-105, 0)
		$Attack_hitbox/CollisionShape2D.position.x = -119
	else: 
		$Animation.offset = Vector2(105, 0)
		$Attack_hitbox/CollisionShape2D.position.x = 119
	$Animation.play("attack")
	await get_tree().create_timer(0.6).timeout
	$Jump.play()
	await get_tree().create_timer(0.8).timeout
	$Attack.play()
	$Attack_hitbox.show()
	$Attack_hitbox.collision_layer = 3
	
	await $Animation.animation_finished
	#await get_tree().create_timer(1.6).timeout
	$Attack_hitbox.collision_layer = 0
	$Attack_hitbox.hide()
	$Animation.stop()
	is_attacking = 0
	$Animation.offset = Vector2.ZERO
	


func _on_hitbox_area_entered(area: Area2D) -> void:
	super.get_hit(area)
