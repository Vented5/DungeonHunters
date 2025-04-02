extends CharacterBody2D
class_name Player

var joystick
@export var health : int = 4
@export var speed = 300
var direction = Vector2.ZERO
signal hit
signal die

var is_attacking = 0

func _ready():
	set_multiplayer_authority(1)
	joystick = get_node("../HUD/Joystick")
	#set_multiplayer_authority(name.to_int())
	print(Global.game_mode, " New player created: ", name)
	$Label.text = name		

	
	if name == str(multiplayer.get_unique_id()):
		add_child(Camera2D.new())
		$"../HUD/Label".text = str(Multiplayer.player_info.name)
	
	#touch_screen.cast.connect(_cast_spell)


func _process(_delta: float): 
	if !is_multiplayer_authority(): return
	# --------------------------- Key Movement ------------------------------
	var vel = Vector2.ZERO 
	if Input.is_action_pressed("move_right"):
		vel.x += 1
		$Animation.flip_h = false
	if Input.is_action_pressed("move_left"):
		vel.x -= 1
		$Animation.flip_h = true
	if Input.is_action_pressed("move_down"):
		vel.y += 1
	if Input.is_action_pressed("move_up"):
		vel.y -= 1
	if vel.length() > 0 and is_attacking == 0:
		vel = vel.normalized() * speed
		$Animation.play("walk")
	
	position += vel * _delta
	
	# ------------------------- Joystick movement -------------------------------
	direction = joystick.pos_vector
	if direction and is_attacking == 0:
		velocity = direction * speed
		if direction.x < 0: $Animation.flip_h = true
		else: $Animation.flip_h = false
		if is_attacking == 0: $Animation.play("walk")
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	
	if !direction and vel == Vector2.ZERO and is_attacking == 0:
		$Animation.play("default")


func init_health():
	$"../HUD/HealthBar".init_health(health)

@rpc("authority")
func get_hit(body: Node2D) -> void:
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

func _cast_spell():
	print("Weeenas ha casteado un spell")
	pass
