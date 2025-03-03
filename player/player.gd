extends CharacterBody2D
@onready var joystick

var speed = 300
var direction = Vector2.ZERO

func _ready():
	#weapon = weapon_scene.instantiate()
	joystick = $"../HUD/Joystick"
	
	$Sprite2D.texture = load(Global.character_texture_path) 
	#weapon.collision_layer = 0
	#add_child(weapon)

func _process(delta: float): 
	# --------------------------- Key Movement ------------------------------
	var vel = Vector2.ZERO 
	if Input.is_action_pressed("move_right"):
		vel.x += 1
		$Sprite2D.flip_h = true
		#weapon.flip_h = true
	if Input.is_action_pressed("move_left"):
		vel.x -= 1
		$Sprite2D.flip_h = false
		#weapon.flip_h = false
	if Input.is_action_pressed("move_down"):
		vel.y += 1
	if Input.is_action_pressed("move_up"):
		vel.y -= 1
	if vel.length() > 0:
		vel = vel.normalized() * speed
	
	position += vel * delta
	
	# ------------------------- Joystick movement -------------------------------
	direction = joystick.pos_vector
	if direction:
		velocity = direction * speed
		#weapon.rotation = direction.angle()
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	if direction.x > 0:  # Derecha
		$Sprite2D.flip_h = true
		#weapon.scale.x = abs(weapon.scale.x)
	elif direction.x < 0:  # Izquierda
		$Sprite2D.flip_h = false
		#weapon.scale.x = -abs(weapon.scale.x)

	# -------------------------- Actions

func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
