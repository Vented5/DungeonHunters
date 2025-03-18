extends Node

var character_texture_path = "res://art/cat.png"
var weapon_scene_path = "res://weapons/sword.tscn"

var save_path = "user://save_game.dat"
var game_mode = "server"

var tag = ""

func _ready():
	if OS.has_feature("dedicated_server"):
		print("Starting a dedicated server...")
		Multiplayer.create_server()

var game_data : Dictionary = {
	"tag": "zzzz",
	"score": 5000
}

func save_highscore(highscore: int):
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_var(game_data)
	save_file = null

func load_game():
	if FileAccess.file_exists(save_path):
		var save_file = FileAccess.open(save_path, FileAccess.READ)
		
		game_data = save_file.get_var()
		save_file = null
		print(game_data)
	#var config = ConfigFile.new()
	#aconfig.set_value("game", "highscore", highscore)
	
	
	#var json_data = JSON.stringify(game_data)
	#	file.store_string(json_data)
	#	file.close()
