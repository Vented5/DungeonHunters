extends TouchScreenButton

#var touch_id
var draw_active = false

var new_line : Vector2
var last_line : Vector2 = Vector2.ZERO
var lines = []
var drawing = [] 
var last_direction = 0

var counter = 0
var delay = 10

@onready var shape_rect : Rect2 = Rect2(position.x - shape.size.x/2, position.y - shape.size.y/2, self.shape.size.x, shape.size.y)

func _ready() -> void:
	#shape_rect = Rect2(shape.position, shape.extends * 2)
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("draw"):
		draw_active = true
		print("Draw active ")
	
	if Input.is_action_just_released("draw"):
		draw_active = false
		lines.clear()
		last_line = Vector2.ZERO
		drawing.clear()
		last_direction = 0
		queue_redraw()

func _draw() -> void:
	for line in lines:
		draw_line(line.from, line.to, Color("000000"), 10.0, false)


func _input(event: InputEvent) -> void:
	counter += 1
	if counter >= delay:
		if event is InputEventScreenDrag and draw_active == true and shape_rect.has_point(event.position):
			new_line = to_local(event.position)
			if last_line != Vector2.ZERO:
				lines.append({"from": last_line, "to": new_line})
				var vector = new_line - last_line
				var new_direction = get_direction(vector.angle())
				if new_direction != last_direction or last_direction == 0:
					drawing.append(new_direction)
				last_direction = new_direction
				print(drawing)
				queue_redraw()
			last_line = new_line
			#print("Touch detectado en: ", event.position, " by: ", event.index, " Draw: ", draw_active)
		counter = 0

func get_direction(angle):
	if angle >= -PI / 8 and angle < PI / 8:
		return 3 #"Derecha 3"
	elif angle >= PI / 8 and angle < 3 * PI / 8:
		return 4 #"Abajo-Derecha 4"
	elif angle >= 3 * PI / 8 and angle < 5 * PI / 8:
		return 5 #"Abajo 5"
	elif angle >= 5 * PI / 8 and angle < 7 * PI / 8:
		return 6 #"Abajo-Izquierda 6"
	elif angle >= 7 * PI / 8 or angle < -7 * PI / 8:
		return 7 #"Izquierda 7"
	elif angle >= -7 * PI / 8 and angle < -5 * PI / 8:
		return 8 #"Arriba-Izquierda 8"
	elif angle >= -5 * PI / 8 and angle < -3 * PI / 8:
		return 1 #"Arriba 1"
	elif angle >= -3 * PI / 8 and angle < PI / 8:
		return 2 #"Aariba-Derecha 2"
	else:
		return 0
