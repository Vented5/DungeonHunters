extends Player

func _ready():
	speed = 500
	super.init_health()
	super._ready()
	$fox_sound.play()

func _process(_delta: float): 
	if !is_multiplayer_authority(): return
	super._process(_delta)
	if Input.is_action_just_released("draw"):
		handle_attack()
	
	#if Input.is_action_just_pressed("attack") and is_attacking==0:
	#	handle_attack()

func handle_attack():
	is_attacking = 1
	$Animation.play("attack")
	await $Animation.animation_finished

	$Animation.stop()
	is_attacking = 0


func _on_hitbox_area_entered(area: Area2D) -> void:
	super.get_hit(area)
