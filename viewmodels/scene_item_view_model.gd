@tool
class_name DH_CSR_SceneItemViewModel
extends RefCounted

signal changed
signal remove_requested(view_model: DH_CSR_SceneItemViewModel)
signal shortcut_requested(view_model: DH_CSR_SceneItemViewModel, key: Key)

var data: DH_CSR_RunnerSceneData

func _init(scene_data: DH_CSR_RunnerSceneData) -> void:
	data = scene_data

func get_scene_name() -> String:
	return data.name

func get_scene_label() -> String:
	return data.scene_path.get_file() if data.scene_path else "Select Scene..."

func get_shortcut_label() -> String:
	if data.keyboard_shortcut != KEY_NONE:
		return OS.get_keycode_string(data.keyboard_shortcut)
	return "Set Shortcut..."

func is_valid_scene() -> bool:
	return data.is_valid_scene()

func get_validation_message() -> String:
	return data.get_validation_message()

func set_scene_name(new_name: String, persist: bool = true) -> void:
	data.name = new_name
	if persist:
		changed.emit()

func commit_changes() -> void:
	changed.emit()

func set_scene_path(new_path: String) -> void:
	data.scene_path = new_path
	changed.emit()

func set_shortcut(key: Key) -> void:
	data.keyboard_shortcut = key
	changed.emit()

func request_shortcut(key: Key) -> void:
	shortcut_requested.emit(self, key)

func request_remove() -> void:
	remove_requested.emit(self)
