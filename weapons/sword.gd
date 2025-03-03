extends Area2D

var radius: float = 150
var attack_tween
var attack_duration: float = 0.2
var direction: Vector2
var initial_angle
var final_angle
var player

func _ready() -> void:
	self.collision_mask &= ~2
	player = self.get_parent()

func _process(delta):
	direction = player.direction
	
	if Input.is_action_just_pressed("attack"):
		handle_attack()

func handle_attack ():
	self.collision_mask |= 2 # Reactiva la mascara de colosion en la posision binaria 2
	print("Máscara modificada:", self.collision_mask)
	attack_tween = create_tween()
	attack_tween.tween_method(attack, 0.0, 1.0, attack_duration)
	await attack_tween.finished
	self.collision_mask &= ~2
	print("Máscara modificada:", self.collision_mask)
		
	position = Vector2.ZERO
	if direction.angle() >= (PI/2):
		self.rotation = deg_to_rad(0)
	else:
		self.rotation = deg_to_rad(250)

func attack(t):
	initial_angle = direction.angle() - PI/4
	final_angle = direction.angle() + PI/4
	
	var current_angle = lerp(initial_angle, final_angle, t)
	
	var x = radius * cos(current_angle)
	var y = radius * sin(current_angle)
	
	self.position = Vector2(x, y)
	self.rotation = current_angle - deg_to_rad(-210)
