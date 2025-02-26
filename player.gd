extends CharacterBody2D
@onready var joystick = $"Camera2D/Joystick"
@export var weapon_scene: PackedScene
var weapon
var weapon_animation
var speed = 300
var direction

var radius: float = 150
var attack_duration: float = 10
var initial_angle
var final_angle
var attack_tween

func _ready():
	#weapon = weapon_scene.instantiate()
	weapon = $Sword
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
	if Input.is_action_just_pressed("jump"):
		attack_tween = create_tween()
		attack_tween.tween_method(attack, 0.0, 1.0, 0.2)
		await attack_tween.finished
		weapon.position = Vector2.ZERO
		if direction.angle() >= (PI/2):
			weapon.rotation = deg_to_rad(0)
		else:
			weapon.rotation = deg_to_rad(250)
	

func attack(t):
	initial_angle = direction.angle() - PI/4
	final_angle = direction.angle() + PI/4
	
	var current_angle = lerp(initial_angle, final_angle, t)
	
	var x = radius * cos(current_angle)
	var y = radius * sin(current_angle)
	
	weapon.position = Vector2(x, y)
	weapon.rotation = current_angle - deg_to_rad(-210)
	
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
