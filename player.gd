extends CharacterBody2D

@onready var joystick = $"Camera2D/Joystick"
var speed = 200
@export var weapon_scene: PackedScene
var weapon

func _ready():
	if weapon_scene:
		weapon = weapon_scene.instantiate()
		add_child(weapon)
	else:
		print("No se asignó una escena para el arma.")

func _process(delta: float):
	# Keyboard movement
	var vel = Vector2.ZERO 
	if Input.is_action_pressed("move_right"):
		vel.x += 1
		$AnimatedSprite2D.flip_h = true
		weapon.flip_h = true
		
	if Input.is_action_pressed("move_left"):
		vel.x -= 1
		$AnimatedSprite2D.flip_h = false
		weapon.flip_h = false
	if Input.is_action_pressed("move_down"):
		vel.y += 1
	if Input.is_action_pressed("move_up"):
		vel.y -= 1
		
	if vel.length() > 0:
		vel = vel.normalized() * speed
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("Idle")
	
	position += vel * delta
	
	# Joystick movement
	var direction = joystick.pos_vector	
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	
	if Input.is_action_pressed("jump"):
		$AnimatedSprite2D.play("jump")
	if Input.is_action_just_released("jump"):
		$AnimatedSprite2D.play("move")
