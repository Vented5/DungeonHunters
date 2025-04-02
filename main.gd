extends Node

var score = 0 : set = set_score
@export var slime_scene: PackedScene
var player_scene = load("res://player/player.tscn")
var player
var slime_count = 1
const MAX_SLIMES = 20

var fireball_scene = load("res://spells/fireball.tscn")

var bear_scene = load("res://characters/bear.tscn")
var dog_scene = load("res://characters/dog.tscn")

func _ready():
	print(Global.game_mode, " players: ", Multiplayer.players)
	if multiplayer.is_server():
		game_start()


func game_start():
	print(Global.game_mode, "----------------- Game start ---------------------")
	for i in Multiplayer.players.keys():
		rpc("spawn_player", i)
	score = 0
	$Slime_timer.start()
	$Golem/AnimatedSprite2D.play("smash")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("test"):
		fireball()

@rpc("call_local", "reliable")
func spawn_player(id):
	#if OS.has_feature("dedicated_server") and id == 1: return
	var player_instance = load(Global.character_path).instantiate()
	player_instance.name = str(id)
	#player_instance.get_node("Sprite2D").texture = load(Multiplayer.players[id].skin)
	player_instance.position = Vector2.ZERO

	if multiplayer.get_unique_id() == id:
		$HUD/HealthBar.init_health(player_instance.health)
		player_instance.hit.connect(_on_player_hit)
		player_instance.die.connect(_on_player_die)
		$HUD/Label.text = str(Multiplayer.players[id].name)
	
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
	$HUD/HealthBar.health = get_node(str(aux)).health

func _on_player_die():
	game_over()

func game_over():
	print("Fin del juego")
	$Game_over/Score.text += str(score)
	$Game_over.show()
	$Slime_timer.stop()
	#Global.save_highscore(5000)
	#print("juego guardado")
	#Global.load_game()

func set_score(value):
	score = value


func _on_exit_game_pressed():
	Multiplayer.multiplayer.multiplayer_peer = null
	get_tree().quit()

func _on_title_screen_pressed():
	Multiplayer.multiplayer.multiplayer_peer = null
	get_tree().change_scene_to_file("res://title_screen/title_screen.tscn")


func _on_new_game_pressed():
	$Game_over.hide()
	game_start()
	

func _on_touch_screen_button_2_cast(drawing) -> void:
	if drawing == [3]:
		fireball()
	else: 	$HUD/Label.text = str(drawing)

func test():
	pass

func fireball():
	$HUD/Label.text = "Fireball"
	var player1 = get_node("1")
	var fireball = fireball_scene.instantiate()
	fireball.position = player1.position
	fireball.rotation = $HUD/Joystick.pos_vector.angle()
	add_child(fireball)
