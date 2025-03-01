extends Sprite2D

var pressing = false

@export var max_length = 50
@export var dead_zone = 5

func _ready():
	max_length *= get_parent().scale.x

func _process(delta):
	if pressing:
		if get_global_mouse_position().distance_to(get_parent().global_position) <= max_length:
			global_position = get_global_mouse_position() 
		else: 
			var angle = get_parent().global_position.angle_to_point(get_global_mouse_position())
			global_position.x = get_parent().global_position.x + cos(angle) * max_length
			global_position.y = get_parent().global_position.y + sin(angle) * max_length
		calculate_vector()
	else:
		global_position = lerp(global_position, get_parent().global_position, delta*50)
		get_parent().pos_vector = Vector2.ZERO
	#print(get_parent().pos_vector)

func calculate_vector():
	if abs(global_position.x - get_parent().global_position.x) >= dead_zone:
		get_parent().pos_vector.x = (global_position.x - get_parent().global_position.x)/max_length
	if abs(global_position.y - get_parent().global_position.y) >= dead_zone:
		get_parent().pos_vector.y = (global_position.y - get_parent().global_position.y)/max_length

func _on_button_button_down():
	pressing = true

func _on_button_button_up():
	pressing = false
