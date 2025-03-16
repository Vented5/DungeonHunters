extends Node

@onready var join_btn: Button = $BoxContainer/Join
var camera_scene = load("res://camera_2d.tscn")

# Instancia el objeto ENetMultiplayerPeer y lo guarda en peer
#var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

func _ready() -> void:
	join_btn.pressed.connect(_on_join_pressed)

func _on_button_pressed() -> void:
	Multiplayer.create_server()
	get_tree().change_scene_to_file("res://character_selection_screen.tscn")
	#print("Scen changed to main")

func _on_host_pressed() -> void:
	Multiplayer.create_server()
	get_tree().change_scene_to_file("res://character_selection_screen.tscn")
	Global.game_mode = "Host" # Host
	

func _on_join_pressed():
	Multiplayer.create_client()
	get_tree().change_scene_to_file("res://character_selection_screen.tscn")
	Global.game_mode = "Client" # Join
	
