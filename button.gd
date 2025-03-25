extends Button

var counter = 0
var delay = 2
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
