extends Node

const SERVER_PORT = 8080
const SERVER_IP = "127.0.0.1"

func createServerPeer():
	var serverPeer = ENetMultiplayerPeer.new()
	serverPeer.create_server(SERVER_PORT)
	multiplayer.multiplayer_peer = serverPeer

func createClientPeer():
	var clientPeer = ENetMultiplayerPeer.new()
	clientPeer.create_client(SERVER_IP, SERVER_PORT)
	multiplayer.multiplayer_peer = clientPeer
