extends CharacterBody2D

signal slime_died

var speed = 100
var direction

func _ready():
	$AnimatedSprite2D.play("move")


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
	
	print("¡Eeeee, contacto!")
	# Desactiva el nodo para que no interactúe con la física inmediatamente
	self.set_process(false)  # Desactiva el proceso para evitar que se actualice
	self.set_physics_process(false)  # Desactiva el procesamiento físico
	# Luego espera un frame para asegurarse de que no haya más procesos pendientes
	await get_tree().create_timer(0.0).timeout
	queue_free()  # Elimina el enemigo
	emit_signal("slime_died")
