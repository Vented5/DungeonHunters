extends Node

var c_texture_folder = "res://art/"
var c_folder = "res://characters/"
var characters = ["dog", "cat", "bear", "fox"] 
var c_selected = 0

func _ready():
	$Select.play()
	load_c_texture()

func _process(delta):
	if Input.is_action_just_pressed("back"):
		_go_back()

func load_c_texture():
	var c_texture = load(c_texture_folder + characters[c_selected] + ".png")
	$C_textureRect.texture = c_texture
	$Character.text = characters[c_selected]


func _on_next_character_pressed() -> void:
	$Select2.play()
	if c_selected == characters.size() -1:
		c_selected = 0
	else:
		c_selected += 1
	load_c_texture()

func _on_prev_character_pressed() -> void:
	$Select2.play()
	if c_selected == 0:
		c_selected = characters.size() -1
	else:
		c_selected -= 1
	load_c_texture()

func _on_start_pressed() -> void:
	#Global.character_texture_path=(c_folder + characters[c_selected] + ".png")
	Global.character_path = (c_folder + characters[c_selected] + ".tscn")
	#if Global.game_mode == "single": 
	#	get_tree().change_scene_to_file("res://main.tscn")
	#	return
	
	Multiplayer.set_player_info.rpc("weapon", Global.weapon_scene_path)
	Multiplayer.set_player_info.rpc("character_path", Global.character_path)
	Multiplayer.set_player_info.rpc("character", characters[c_selected])
	Multiplayer.player_loaded.rpc(multiplayer.get_unique_id())


func _on_back_pressed() -> void:
	_go_back()

func _go_back():
	get_tree().change_scene_to_file("res://screens/title_screen/title_screen.tscn")
	#if Global.game_mode != "single": multiplayer.multiplayer_peer = null
	Multiplayer.multiplayer.multiplayer_peer = null
	if Multiplayer.multiplayer.multiplayer_peer:
		print(Multiplayer.multiplayer.multiplayer_peer)
	else: print("session clossed")
