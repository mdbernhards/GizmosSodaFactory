extends Control

const GAME_SCENE = "res://Scenes/game.tscn"

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_host_game_button_button_down() -> void:
	get_tree().call_deferred(&"change_scene_to_packed", preload(GAME_SCENE))
	NetworkManager.hostGame()

func _on_join_game_button_button_down() -> void:
	get_tree().call_deferred(&"change_scene_to_packed", preload(GAME_SCENE))
	NetworkManager.joinGame()

func _on_quit_button_button_down() -> void:
	get_tree().quit()
