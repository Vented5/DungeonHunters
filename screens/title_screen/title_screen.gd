extends Node

@onready var join_btn: Button = $BoxContainer/Join
# Instancia el objeto ENetMultiplayerPeer y lo guarda en peer
#var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
var character_selection = "res://screens/character_selection/character_selection_screen.tscn"

func _ready() -> void:
	join_btn.pressed.connect(_on_join_pressed)
	$Welcome/Timer.start()

func _on_start_pressed() -> void:
	Multiplayer.create_server()
	get_tree().change_scene_to_file(character_selection)
	Global.game_mode = "single"

func _on_button_pressed() -> void:
	Multiplayer.create_client()
	get_tree().change_scene_to_file(character_selection)
	Global.game_mode = "Client" # Join

func _on_host_pressed() -> void:
	
	Multiplayer.create_server()
	get_tree().change_scene_to_file(character_selection)
	Global.game_mode = "Host" # Host
	

func _on_join_pressed():
	$Server_list.visible = !$Server_list.visible


func _on_timer_timeout() -> void:
	$Welcome.show()


func _on_tag_btn_pressed() -> void:
	Global.tag = $Welcome/LineEdit.text
	$Welcome.hide()
