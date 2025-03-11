extends Node

var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
var player_scene = load("res://player/player.tscn")

func create_server(port:int, max_players: int):
	peer.create_server(port, max_players)
	multiplayer.multiplayer_peer = peer

	multiplayer.peer_connected.connect(spawn_player)

func create_client(ip: String, port: int):
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	print("Cliente conectado a: ", multiplayer.multiplayer_peer) 
	#print("----------  Arbol del cliente -----------")
	#get_parent().print_tree_pretty()

func spawn_player(id: int = 1) -> void:
	var player_instance = player_scene.instantiate()
	player_instance.name = str(id)
	#call_deferred("add_child", player_instance, true)
	var scene = get_tree().current_scene
	scene.add_child(player_instance, true)

	print("----------  Arbol actualizado -----------")
	print("Game mode: ", Global.game_mode)
	get_parent().print_tree_pretty()
	#player_instance.add_child(Camera2D.new())
	
