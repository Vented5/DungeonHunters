extends Node

var score = 0 : set = set_score
@export var slime_scene: PackedScene
var player
var slime_count = 1
const MAX_SLIMES = 50

var fireball_scene = load("res://spells/fireball.tscn")
var cast_scene = load("res://cast_button.tscn")

var url = "http://luckysw.xyz:3000/scores"
@onready var http_request = $HTTPRequest

func _ready():
	print(Global.game_mode, " players: ", Multiplayer.players)
	if multiplayer.is_server():
		game_start()
	$Select.play()
	
	http_request.request_completed.connect(_on_request_completed)
	
func send_data(data):
	var json = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	http_request.request(url, headers, HTTPClient.METHOD_POST, json)


func _on_request_completed(res, res_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json)
	if json:
		if json.message:
			pass
			#$Game_over/Label.text = json.message 

func game_start():
	$AudioStreamPlayer.play()
	print_tree_pretty()
	print(Global.game_mode, "----------------- Game start ---------------------")
	for i in Multiplayer.players.keys():
		rpc("spawn_player", i)
	score = 0
	$Slime_timer.start()
	#$Golem/AnimatedSprite2D.play("smash")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("test"):
		fireball(player.position)

@rpc("call_local", "reliable")
func spawn_player(id):
	#if OS.has_feature("dedicated_server") and id == 1: return
	#var player_instance = load(Global.character_path).instantiate()
	#player_instance.name = str(id)
	var player_instance = load(Multiplayer.players[id].character_path).instantiate()
	#player_instance.get_node("Sprite2D").texture = load(Multiplayer.players[id].skin)
	player_instance.set_multiplayer_authority(id)
	player_instance.position = Vector2.ZERO

	if multiplayer.get_unique_id() == id:
		player = player_instance
		player_instance.hit.connect(_on_player_hit)
		player_instance.die.connect(_on_player_die)
		print(player.name)
		if player.name == "Fox":
			var cast_button = cast_scene.instantiate()
			cast_button.cast.connect(_on_touch_screen_button_2_cast)
			$HUD.add_child(cast_button)
			$HUD/TouchScreenButton.hide()
			
	
	add_child(player_instance)
	print(Global.game_mode," Jugador ", id,  " spawned at: ", player_instance. position)

func _on_slime_timer_timeout():
	if slime_count >= MAX_SLIMES + 1: return
	var mob_spawn = $Mob_spawn_path/Mob_spawn_location
	mob_spawn.progress_ratio = randf_range(0.0, 1.0)
	var pos = mob_spawn.position
	rpc("_spawn_slime", pos)

@rpc("any_peer", "call_local", "reliable")
func _spawn_slime(pos):
	var slime = slime_scene.instantiate()
	slime.get_node("Label").text = str(slime_count)
	slime.set_position(pos)
	slime.die.connect(_on_slime_died)
	#print("Slime spawned: ", slime)
	add_child(slime)
	slime_count += 1


func _on_slime_died():
	score += 100
	slime_count -= 1
	if !OS.has_feature("dedicated_server"):
		$HUD/Score.text = "Score: " + str(score)


func _on_player_hit():
	var aux = multiplayer.get_unique_id()
	$HUD/HealthBar.health = player.health

func _on_player_die():
	game_over()

func game_over():
	print("Fin del juego")
	$Game_over/Score.text += str(score)
	$Game_over.show()
	$Slime_timer.stop()
	$AudioStreamPlayer.stop()
	$Game_over_sound.play()
	var data = { tag = Global.tag, score = score}
	send_data(data)

func set_score(value):
	score = value


func _on_exit_game_pressed():
	Multiplayer.multiplayer.multiplayer_peer = null
	get_tree().quit()

func _on_title_screen_pressed():
	Multiplayer.multiplayer.multiplayer_peer = null
	get_tree().change_scene_to_file("res://screens/title_screen/title_screen.tscn")


func _on_new_game_pressed():
	$Game_over.hide()
	game_start()
	

func _on_touch_screen_button_2_cast(drawing) -> void:
	# medialuna izquierda 4567812
	if drawing.contains("45678"):
		fireball(player.position)
		#rpc_id(1, "fireball", player.position)
	else: 	$HUD/Label.text = str(drawing)

func test():
	pass

@rpc("call_local", "reliable")
func fireball(pos):
	$HUD/Label.text = "Fireball"
	var fireball = fireball_scene.instantiate()
	fireball.position = pos
	fireball.rotation = $HUD/Joystick.pos_vector.angle()
	add_child(fireball)
