@tool
class_name DH_CSR_RunnerSceneData 
extends Resource

@export var name: String
@export var keyboard_shortcut: Key
@export_file("*.tscn") var scene_path: String

func _init(name_: String = "", keyboard_shortcut_: Key = KEY_NONE, scene_path_: String = "") -> void:
	name = name_
	keyboard_shortcut = keyboard_shortcut_
	scene_path = scene_path_

func is_complete() -> bool:
	return not scene_path.is_empty()

func is_valid_scene() -> bool:
	return is_complete() and scene_path.get_extension().to_lower() == "tscn" and ResourceLoader.exists(scene_path)

func get_display_name() -> String:
	var clean_name: String = name.strip_edges()
	if not clean_name.is_empty():
		return clean_name
	if not scene_path.is_empty():
		return scene_path.get_file().get_basename()
	return "Unnamed Scene"

func get_validation_message() -> String:
	if scene_path.is_empty():
		return "Select a .tscn scene."
	if scene_path.get_extension().to_lower() != "tscn":
		return "Scene must be a .tscn file: " + scene_path
	if not ResourceLoader.exists(scene_path):
		return "Scene does not exist: " + scene_path
	return ""
