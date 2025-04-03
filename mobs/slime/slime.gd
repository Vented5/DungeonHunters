extends CharacterBody2D

signal die

@export var health = 2 : set = _set_health
var speed = 100
var direction
var nearest : Vector2
@onready var healthbar 
var stun = false


func _ready():	
	speed = randi_range(100, 150)
	if !OS.has_feature("dedicated_server"):
		healthbar = $HealthBar
		healthbar.init_health(health)
		$AnimatedSprite2D.play("move")
	direction = randf()

func _process(delta):
	if !multiplayer.is_server(): return
	
	var closest = get_closest()
	if closest:
		direction = get_angle_to(closest.position)
	
	if !stun: move(direction)

func get_closest():
	var nodo_mas_cercano = null
	var menor_distancia = INF
	for nodo in get_tree().get_nodes_in_group("characters"):
		var distancia = global_position.distance_to(nodo.global_position)
		if distancia < menor_distancia:
			menor_distancia = distancia
			nodo_mas_cercano = nodo
	return nodo_mas_cercano


@rpc("call_local", "any_peer", "unreliable")
func move(dir):
	velocity = Vector2(speed, 0.0).rotated(dir) 
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D):
	# ------ Movi todo a un area2d -----------------
	# No funciona si el arma es un objeto, por alguna razon este se queda tiezo en el mapa
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:	
	#if !multiplayer.is_server(): return
	if area.name == "Arrow":
		rpc("_set_health", health - 2)
	else:
		rpc("_set_health", health - 1)
	$Hit.play()
	$AnimatedSprite2D.play("hit")
	if area.get_parent().name != "Bear": 
		await get_tree().create_timer(1).timeout
	else:
		stun = true
		await get_tree().create_timer(2).timeout
	stun = false
	$AnimatedSprite2D.play("move")

@rpc("any_peer", "call_local", "unreliable")
func _set_health(value):
	health = value
	if health <= 0:
		emit_signal("die")
		$Die.play()
		stun = true
		self.collision_layer = 0
		await get_tree().create_timer(0.5).timeout
		queue_free()

	if !OS.has_feature("dedicated_server"):
		healthbar = $HealthBar
		healthbar.health = health

func update_position(pos:Vector2):
	pass
