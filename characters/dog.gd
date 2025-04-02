extends Player

func _ready():
	super._ready()

func _process(_delta: float): 
	super._process(_delta)
	
	if Input.is_action_just_pressed("attack") and is_attacking==0:
		handle_attack()

func handle_attack():
	is_attacking = 1
	if $Animation.flip_h: 
		$Animation.offset = Vector2(-105, 0)
		$Sword_hit/CollisionShape2D.position.x = -119
	else: 
		$Animation.offset = Vector2(105, 0)
		$Sword_hit/CollisionShape2D.position.x = 119
	$Animation.play("attack")
	await get_tree().create_timer(1.4).timeout
	$Sword_hit.show()
	$Sword_hit.collision_layer = 3
	
	await $Animation.animation_finished
	#await get_tree().create_timer(1.6).timeout
	$Sword_hit.collision_layer = 0
	$Sword_hit.hide()
	$Animation.stop()
	is_attacking = 0
	$Animation.offset = Vector2.ZERO
	
