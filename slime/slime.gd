extends CharacterBody2D

signal slime_died

var health = 10 : set = _set_health
var speed = 100
var direction
@onready var healthbar = $HealthBar
@onready var player = get_parent().get_node("Player")

@rpc("authority")
func _ready():
	health = 2
	healthbar.init_health(health)
	$AnimatedSprite2D.play("move")
	direction = randf()

@rpc("authority")
func _process(delta):
	rpc("move")
	if player:
		direction = get_angle_to(player.position)

@rpc("call_remote")
func move():
	velocity = Vector2(speed, 0.0).rotated(direction) 
	#move_and_slide()

@rpc("authority")
func _on_area_2d_body_entered(body: Node2D):
	# ------ Movi todo a un area2d -----------------
	# No funciona si el arma es un objeto, por alguna razon este se queda tiezo en el mapa
	pass


@rpc("authority")
func _on_area_2d_area_entered(area: Area2D) -> void:
	
	print("¡Eeeee, contacto!")
	# Desactiva el nodo para que no interactúe con la física inmediatamente
	#self.set_process(false)  # Desactiva el proceso para evitar que se actualice
	#self.set_physics_process(false)  # Desactiva el procesamiento físico
	# Luego espera un frame para asegurarse de que no haya más procesos pendientes
	await get_tree().create_timer(0.0).timeout
	health -= 1  # Elimina el enemigo


@rpc("authority")
func _set_health(value):
	#self._set_health(value)
	health = value
	if health <= 0:
		self.collision_layer = 0
		queue_free()
		emit_signal("slime_died")
	
	healthbar.health = health
