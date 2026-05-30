@tool
class_name DH_CSR_SceneItemViewModel
extends RefCounted

## ViewModel for a single scene row. Wraps one DH_CSR_RunnerSceneData and
## exposes display strings + commands. Holds no UI references.

signal changed
signal remove_requested(view_model: DH_CSR_SceneItemViewModel)

var data: DH_CSR_RunnerSceneData
var capturing_shortcut: bool = false

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

func set_scene_name(new_name: String) -> void:
	data.name = new_name
	changed.emit()

func set_scene_path(new_path: String) -> void:
	data.scene_path = new_path
	changed.emit()

func begin_capture_shortcut() -> void:
	capturing_shortcut = true

func set_shortcut(key: Key) -> void:
	data.keyboard_shortcut = key
	capturing_shortcut = false
	changed.emit()

func request_remove() -> void:
	remove_requested.emit(self)
