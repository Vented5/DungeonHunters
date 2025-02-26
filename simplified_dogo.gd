extends CharacterBody2D

@onready var joystick = $"Camera2D/Joystick"

@export var weapon_scene: PackedScene
var weapon
var weapon_animation

var speed = 200

func _ready():
	weapon = weapon_scene.instantiate()
	add_child(weapon)
	weapon_animation = weapon.get_node("AnimationPlayer")
	

func _process(delta: float):
	var vel = Vector2.ZERO 
	if Input.is_action_pressed("move_right"):
		vel.x += 1
		#$AnimatedSprite2D.flip_h = true
		$Sprite2D.flip_h = true
		weapon.flip_h = true
		
	if Input.is_action_pressed("move_left"):
		vel.x -= 1
		#$AnimatedSprite2D.flip_h = false
		$Sprite2D.flip_h = false
		weapon.flip_h = false
	if Input.is_action_pressed("move_down"):
		vel.y += 1
	if Input.is_action_pressed("move_up"):
		vel.y -= 1
	
	if vel.length() > 0:
		vel = vel.normalized() * speed
	
	position += vel * delta
	
	var direction = joystick.pos_vector
	if direction:
		velocity = direction * speed
		#weapon.rotation = direction.angle()
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	#Orientar el arme
	if direction.x > 0:  # Derecha
		$Sprite2D.flip_h = true
		weapon.scale.x = abs(weapon.scale.x)
	elif direction.x < 0:  # Izquierda
		$Sprite2D.flip_h = false
		weapon.scale.x = -abs(weapon.scale.x)
	
	
	if Input.is_action_pressed("jump"):
		weapon_animation.play("attack")
	if Input.is_action_just_released("jump"):
		weapon_animation.play("RESET")
