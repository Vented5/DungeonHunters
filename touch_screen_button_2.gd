extends TouchScreenButton

#var touch_id
var draw_active = false

var new_line : Vector2
var last_line : Vector2 = Vector2.ZERO
var lines = []

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
		queue_redraw()

func _draw() -> void:
	for line in lines:
		draw_line(line.from, line.to, Color("000000"), 10.0, false)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag and draw_active == true and shape_rect.has_point(event.position):
		new_line = to_local(event.position)
		lines.append({"from": last_line, "to": new_line})
		queue_redraw()
		last_line = new_line
		print("Touch detectado en: ", event.position, " by: ", event.index, " Draw: ", draw_active)
