extends Node

var folder = "res://art/"
var characters = ["dog", "cat", "bear", "fox"] 
var selected = 1

func _ready():
	load_texture()

func load_texture():
	var texture = load(folder + characters[selected] + ".png")
	$TextureRect.texture = texture
	$Character.text = characters[selected]

func _on_next_pressed() -> void:
	if selected == characters.size() -1:
		selected = 0
	else:
		selected += 1
	load_texture()

func _on_prev_pressed() -> void:
	if selected == 0:
		selected = characters.size() -1
	else:
		selected -= 1
	load_texture()

func _on_start_pressed() -> void:
	Global.character_texture_path=(folder + characters[selected] + ".png")
	get_tree().change_scene_to_file("res://main.tscn")
