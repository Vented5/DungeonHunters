extends Node

var score: int
@export var slime_scene: PackedScene
var player_scene = load("res://player/player.tscn")
var player

func _ready():
	Multiplayer.player_loaded.rpc_id(1)
	#$HUD/HealthBar.init_health($Player.health)
	
	player = get_node("./" + str(Multiplayer.player))

	#player.add_child(Camera2D.new())
	#if $"./1":
	#	$"./1".add_child(Camera2D.new())

func game_start():
	print(Global.game_mode, " Game start")
	for i in Multiplayer.players.keys():
		spawn_player(i)
	
	score = 0
	$Slime_timer.start()

func game_over():
	print("Fin del juego")
	$Game_over.show()
	Global.save_highscore(5000)
	print("juego guardado")
	Global.load_game()

@rpc("authority")
func spawn_player(peer_id: int):
	var player_instance = player_scene.instantiate()
	player_instance.name = str(peer_id)
	player_instance.position = Vector2.ZERO
	add_child(player_instance)
	rpc_id(peer_id, "initialize_player", player_instance.position, "reliable")
	print(Global.game_mode, "Jugador ", peer_id,  " spawned at: ", player_instance. position)

@rpc("call_remote")
func initialize_player(start_position):
	var player_instance = player_scene.instantiate()
	player_instance.position = start_position
	add_child(player_instance)

func _on_slime_timer_timeout():
	var slime = slime_scene.instantiate()
	var mob_spawn = $Mob_spawn_path/Mob_spawn_location
	mob_spawn.progress_ratio = randf_range(0.0, 1.0)
	slime.position = mob_spawn.position
	add_child(slime)
	slime.connect("slime_died", _on_slime_died, 0)

func _on_slime_died():
	score += 100
	$HUD/Score.text = str(score)


func _on_player_hit() -> void:
	$HUD/HealthBar.health = $Player.health

func _on_player_die() -> void:
	$Slime_timer.stop()
	game_over()
