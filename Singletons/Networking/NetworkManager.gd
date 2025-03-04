extends Node

const SERVER_PORT = 8080
const SERVER_IP = "127.0.0.1"

var multiplayerPlayerScene = preload("res://Scenes/Player/multiplayerPlayer.tscn")

var IsHost = false
var PlayersInGame = {}

func hostGame():
	IsHost = true
	
	CustomENetNetwork.createServerPeer()
	
	multiplayer.peer_connected.connect(addPlayer)
	multiplayer.peer_disconnected.connect(removePlayer)
	
	addPlayer(1)

func joinGame():
	CustomENetNetwork.createClientPeer()

func addPlayer(playerId):
	print("Player %s joined the game!" % playerId)
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	var newPlayer = multiplayerPlayerScene.instantiate()
	newPlayer.PlayerId = playerId
	newPlayer.name = str(playerId)
	newPlayer.position = Vector3(randi_range(-2, 2), 1, randi_range(-2, 2))
	
	PlayersInGame[playerId] = newPlayer
	
	get_tree().get_first_node_in_group("PlayerSpawnNode").add_child(newPlayer, true)

func removePlayer(playerId):
	print("Player %s left the game!" % playerId)
	
	if PlayersInGame.has(playerId):
		var playerToRemove = PlayersInGame[playerId]
		PlayersInGame.erase(playerId)
		
		if playerToRemove:
			playerToRemove.queue_free()
