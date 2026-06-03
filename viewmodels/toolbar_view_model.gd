@tool
class_name DH_CSR_ToolbarViewModel
extends RefCounted

signal scenes_changed(scenes: Array[DH_CSR_RunnerSceneData])
signal open_selector_requested

var _repository: DH_CSR_ScenesRepository
var _scenes: Array[DH_CSR_RunnerSceneData] = []

func _init(repository: DH_CSR_ScenesRepository) -> void:
	_repository = repository

func reload() -> void:
	_scenes = []
	for scene_data: DH_CSR_RunnerSceneData in _repository.load_scenes():
		if scene_data.is_valid_scene():
			_scenes.append(scene_data)
	scenes_changed.emit(_scenes)

func get_scenes() -> Array[DH_CSR_RunnerSceneData]:
	return _scenes

func request_open_selector() -> void:
	open_selector_requested.emit()

func run_scene(index: int) -> void:
	index = index - 2
	if index >= 0 and index < _scenes.size():
		var scene_data: DH_CSR_RunnerSceneData = _scenes[index]
		if not scene_data.is_valid_scene():
			push_warning("CustomSceneRunner: " + scene_data.get_validation_message())
			return
		EditorInterface.play_custom_scene(scene_data.scene_path)
