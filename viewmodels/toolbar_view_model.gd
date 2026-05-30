@tool
class_name DH_CSR_ToolbarViewModel
extends RefCounted

## ViewModel for the toolbar popup menu. Loads scenes for display and runs the
## selected one. No UI references. Navigation is exposed as intent only: the
## coordinator (plugin) listens to open_selector_requested and performs the UI.

signal scenes_changed(scenes: Array[DH_CSR_RunnerSceneData])
signal open_selector_requested

var _repository: DH_CSR_ScenesRepository
var _scenes: Array[DH_CSR_RunnerSceneData] = []

func _init(repository: DH_CSR_ScenesRepository = DH_CSR_ScenesRepository.new()) -> void:
	_repository = repository

func reload() -> void:
	_scenes = _repository.load_scenes()
	scenes_changed.emit(_scenes)

func get_scenes() -> Array[DH_CSR_RunnerSceneData]:
	return _scenes

func request_open_selector() -> void:
	open_selector_requested.emit()

func run_scene(index: int) -> void:
	if index >= 0 and index < _scenes.size():
		EditorInterface.play_custom_scene(_scenes[index].scene_path)
