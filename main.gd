extends Node

var score: int
@export var slime_scene: PackedScene
@export var player_scene: PackedScene
var mob_spawn

func _ready():
	#var player = player_scene.instantiate()
	#player.position = Vector2(640, 360)
	#add_child(player)
	
	mob_spawn = $Mob_spawn_path/Mob_spawn_location
	$Slime_timer.start()

func _process(delta: float) -> void:
	pass

func new_game():
	score = 0

func _on_slime_timer_timeout():
	var slime = slime_scene.instantiate()
	mob_spawn.progress_ratio = randf()
	slime.position = mob_spawn.position
	add_child(slime)
	slime.connect("slime_died", _on_slime_died, 0)

func _on_slime_died():
	score += 100
	update_score_label()

func update_score_label():
	$HUD/Score.text = str(score)
