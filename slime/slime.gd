extends CharacterBody2D

signal die

@export var health = 2 : set = _set_health
var speed = 100
var direction

@onready var healthbar 

func _ready():
	if !OS.has_feature("dedicated_server"):
		healthbar = $HealthBar
		healthbar.init_health(health)
		$AnimatedSprite2D.play("move")
	direction = randf()

func _process(delta):
	if !multiplayer.is_server(): return
	var player = get_parent().get_node("1")
	if player:
		direction = get_angle_to(player.position)
	
	rpc("move", direction)

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
	rpc("_set_health", health - 1)
	

@rpc("any_peer", "call_local", "unreliable")
func _set_health(value):
	health = value
	if health <= 0:
		self.collision_layer = 0
		emit_signal("die")
		queue_free()

	if !OS.has_feature("dedicated_server"):
		healthbar = $HealthBar
		healthbar.health = health

func update_position(pos:Vector2):
	pass
