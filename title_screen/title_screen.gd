extends Node

@onready var join_btn: Button = $BoxContainer/Join
var player_scene = load("res://player/player.tscn")
var camera_scene = load("res://camera_2d.tscn")

# Instancia el objeto ENetMultiplayerPeer y lo guarda en peer
var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

func _ready() -> void:
	join_btn.pressed.connect(_on_join_pressed)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://character_selection_screen.tscn")
	#print("Scen changed to main")

func _on_host_pressed() -> void:
	#Crea el servidor con el puerto y el maximo de clientes
	peer.create_server(3500, 2) # Acepta cualquier puerto a partir del 1024
	multiplayer.multiplayer_peer = peer # Establece esta sesion como sesion conectada actual
	multiplayer.peer_connected.connect(_on_peer_connected) # Conecta la se;al on peer conected a la funcion
	#get_tree().change_scene_to_file("res://main.tscn")
	_on_peer_connected()


func _on_join_pressed():
	peer.create_client("localhost", 3500)
	multiplayer.multiplayer_peer = peer

func _on_peer_connected(id: int = 1):
	var player_instance = player_scene.instantiate()
	#player_instance.position = Vector2(100, 0)
	add_child(player_instance, true)
	print("Jugador spawneado en:", player_instance.position)
