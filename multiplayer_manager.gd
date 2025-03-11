extends Node

var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

func create_server(port:int, max_players: int):
	peer.create_server(port, max_players)
	multiplayer.multiplayer_peer = peer

	multiplayer.peer_connected.connect(_on_peer_connected)
	

func create_client(ip: String, port: int):
	peer.create_client(ip, port)
	Global.player = peer.get_unique_id()
	Global.players.append(Global.player)
	multiplayer.multiplayer_peer = peer

func _on_peer_connected(id):
	print(Global.game_mode, " Connection with: ", id)
	Global.players.append(id)
	
	
