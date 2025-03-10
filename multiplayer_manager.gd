extends Node

var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

func create_server(port:int, max_players: int):
	peer.create_server(port, max_players)
	multiplayer.multiplayer_peer = peer

	multiplayer.peer_connected.connect(spawn_player)
	spawn_player()

func create_client(ip: String, port: int):
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer

var player_scene = load("res://player/player.tscn")

@rpc("any_peer", "call_local")
func spawn_player(id: int = 1) -> void:
	var player_instance = player_scene.instantiate()
	player_instance.name = str(id)
	#call_deferred("add_child", player_instance, true)
	var scene = get_tree().current_scene
	scene.add_child(player_instance, true)
	
