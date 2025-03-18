extends Node

signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

const PORT = 7769
const DEFAULT_SERVER_IP = "127.0.0.1"#"luckysw.xyz"#192.168.0.2"#172.17.0.2"###"26.68.79.202"#
const MAX_CONECTIONS = 4

var players = {}
var player_info = { "name": "Weeenas", "weapon": ""}
var player = 1
var players_loaded = 0

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func create_server():
	var peer = ENetMultiplayerPeer.new()
	
	var error = peer.create_server(PORT, MAX_CONECTIONS)
	if error != OK:
		print("Error al crear servidor: ", error)
		return error
	multiplayer.multiplayer_peer = peer
	print("Servidor escuchando en: ", PORT)
	#player_info.name = "server"
	if !OS.has_feature("dedicated_server"):
		player_info.name = Global.tag
		players[1] = player_info
		player_connected.emit(1, player_info)

func create_client(ip = ""):
	if ip.is_empty():
		ip = DEFAULT_SERVER_IP
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	player = peer.get_unique_id()
	multiplayer.multiplayer_peer = peer

# When a peer connects, send them my player info.
# This allows transfer of all desired data for each player, not only the unique ID.
func _on_player_connected(id):
	player_info.name = Global.tag
	_register_player.rpc_id(id, player_info)
	print(Global.game_mode, " Player connected: ", id)

@rpc("any_peer", "call_local", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)
	print(Global.game_mode, " La lista de jugadores es: ", players)

# When the server decides to start the game from a UI scene,
# do Lobby.load_game.rpc(filepath)
@rpc("any_peer", "call_local", "reliable")
func load_game(game_scene_path):
	get_tree().change_scene_to_file(game_scene_path)

@rpc("any_peer", "call_local", "reliable")
func player_loaded(id):
	if multiplayer.is_server():
		players_loaded += 1
		print(Global.game_mode, " - loaded: ", players_loaded, " id: ", id)
		if players_loaded == players.size():
			rpc("load_game", "res://main.tscn")
			players_loaded = 0
			

@rpc("any_peer", "call_local", "reliable")
func set_player_info(key, value):
	players[multiplayer.get_remote_sender_id()][key] = value

func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)

func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)

func _on_connected_fail():
	multiplayer.multiplayer_peer = null
	print("Conection failed.")

func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()
	print("Server disconnected")
