extends Node

@export var slime_scene: PackedScene
@export var player_scene: PackedScene

func _ready():
	#var player = player_scene.instantiate()
	#player.position = Vector2(640, 360)
	#add_child(player)
	
	var mob_spawn = $Mob_spawn_path/Mob_spawn_location
	
	for i in 2:
		var slime = slime_scene.instantiate()
		mob_spawn.progress_ratio = randf()
		slime.position = mob_spawn.position
		add_child(slime)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
