extends Node

var c_folder = "res://art/"
var characters = ["dog", "cat", "bear", "fox"] 
var c_selected = 1
var w_folder = "res://weapons/"
var weapons = ["sword", "bow"]
var w_selected = 1

func _ready():
	load_c_texture()
	load_w_texture()

func load_c_texture():
	var c_texture = load(c_folder + characters[c_selected] + ".png")
	$C_textureRect.texture = c_texture
	$Character.text = characters[c_selected]

func load_w_texture():
	var w_texture = load(w_folder + weapons[w_selected] + ".png")
	$W_textureRect.texture = w_texture
	$Weapon.text = weapons[w_selected]

func _on_next_character_pressed() -> void:
	if c_selected == characters.size() -1:
		c_selected = 0
	else:
		c_selected += 1
	load_c_texture()

func _on_prev_character_pressed() -> void:
	if c_selected == 0:
		c_selected = characters.size() -1
	else:
		c_selected -= 1
	load_c_texture()

func _on_start_pressed() -> void:
	Global.character_texture_path=(c_folder + characters[c_selected] + ".png")
	Global.weapon_scene_path=(w_folder + weapons[w_selected] + ".tscn")
	Multiplayer.player_loaded.rpc_id(1)
	#get_tree().change_scene_to_file("res://main.tscn")
	

func _on_next_weapon_pressed() -> void:
	if w_selected == weapons.size() -1:
		w_selected = 0
	else:
		w_selected += 1
	load_w_texture()

func _on_prev_weapon_pressed() -> void:
	if w_selected == 0:
		w_selected = weapons.size() -1
	else:
		w_selected -= 1
	load_w_texture()
