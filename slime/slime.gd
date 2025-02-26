extends CharacterBody2D

var speed = 100
var direction
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("move")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = get_parent().get_node("Player")
	direction = get_angle_to(player.position)
	velocity = Vector2(speed, 0.0).rotated(direction) 
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D):
	# ------ Movi todo a un area2d -----------------
	# No funciona si el arma es un objeto, por alguna razon este se queda tiezo en el mapa
	pass
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.collision_layer == 1 and $"../Player/Sword".collision_mask == 2:  #  Solo detecta si la capa 2 (slimes) está activada
		print("¡La espada golpeó un slime!, mascara:", $"../Player/Sword".collision_mask)
		print("¡Eeeee, contacto!")
		# Desactiva el nodo para que no interactúe con la física inmediatamente
		self.set_process(false)  # Desactiva el proceso para evitar que se actualice
		self.set_physics_process(false)  # Desactiva el procesamiento físico
		# Luego espera un frame para asegurarse de que no haya más procesos pendientes
		await get_tree().create_timer(0.0).timeout
		queue_free()  # Elimina el enemigo
