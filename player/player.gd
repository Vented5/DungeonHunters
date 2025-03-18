extends CharacterBody2D
@onready var joystick

@export var health = 4
@export var speed = 300
var direction = Vector2.ZERO
signal hit
signal die

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	print(Global.game_mode, " New player created: ", name)
	$Label.text = name

func _ready():
	joystick = $"../HUD/Joystick"
	
	#$Sprite2D.texture = load(Global.character_texture_path) 
	
	if name == str(multiplayer.get_unique_id()):
		add_child(Camera2D.new())

func _process(delta: float): 
	if !is_multiplayer_authority(): return
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
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	if direction.x > 0:  # Derecha
		$Sprite2D.flip_h = true
	elif direction.x < 0:  # Izquierda
		$Sprite2D.flip_h = false

@rpc("authority")
func _on_area_2d_body_entered(body: Node2D) -> void:
	if !is_multiplayer_authority(): return
	health -= 1
	hit.emit()
	if health <= 0:
		queue_free()
		#self.visible = false
		#$Area2D.collision_mask = 0
		die.emit()
		print("Player ", multiplayer.get_unique_id(), " has died")
	print(Global.game_mode, " Slime contact, health: ", health)
