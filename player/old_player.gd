extends CharacterBody2D

#@onready var joystick = $"Camera2D/Joystick"
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
	
	$AnimatedSprite2D.play("walk")
	
	
	# Joystick movement
	#var direction = joystick.pos_vector	
	#if direction:
	#	velocity = direction * speed
	#else:
	#	velocity = Vector2.ZERO
	#move_and_slide()
	
	#if Input.is_action_pressed("jump"):
	#	$AnimatedSprite2D.play("jump")
	#if Input.is_action_just_released("jump"):
	#	$AnimatedSprite2D.play("move")
