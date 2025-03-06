extends Node

var score: int
@export var slime_scene: PackedScene
@export var player_scene: PackedScene

func _ready():	
	$Slime_timer.start()
	$HUD/HealthBar.init_health($Player.health)

func new_game():
	score = 0

func game_over():
	print("Fin del juego")
	$Game_over.show()

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
