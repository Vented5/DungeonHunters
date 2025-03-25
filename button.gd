extends Button

var counter = 0
var delay = 20
var last_position : Vector2 = Vector2.ZERO
var new_position : Vector2
var lines = []

func _process(delta: float) -> void:
	counter += 1
	if counter >= delay:
		if button_pressed:
			new_position = get_local_mouse_position()
			if last_position != Vector2.ZERO: 
				lines.append({"from": last_position, "to": new_position})
				var vector = new_position - last_position
				print("angle to: ", vector.angle())
				print(get_direction(vector.angle()))
			last_position = new_position
			queue_redraw()
			#print(get_viewport().get_mouse_position())
		else:
			last_position = Vector2.ZERO  # Reset al soltar
			lines.clear()
		counter = 0

func _draw() -> void:
	if button_pressed:
		for line in lines:
			draw_line(line.from, line.to, Color("000000"), 10.0, false)
			
func get_direction(angle):	
	if angle >= -PI / 8 and angle < PI / 8:
		return "Derecha"
	elif angle >= PI / 8 and angle < 3 * PI / 8:
		return "Abajo-Derecha"
	elif angle >= 3 * PI / 8 and angle < 5 * PI / 8:
		return "Abajo"
	elif angle >= 5 * PI / 8 and angle < 7 * PI / 8:
		return "Abajo-Izquierda"
	elif angle >= 7 * PI / 8 or angle < -7 * PI / 8:
		return "Izquierda"
	elif angle >= -7 * PI / 8 and angle < -5 * PI / 8:
		return "Arriba-Izquierda"
	elif angle >= -5 * PI / 8 and angle < -3 * PI / 8:
		return "Arriba"
	elif angle >= -3 * PI / 8 and angle < PI / 8:
		return "Aariba-Derecha"
	else:
		# Si no coincide con ninguno de los casos, se devuelve un valor predeterminado.
		return "null"
