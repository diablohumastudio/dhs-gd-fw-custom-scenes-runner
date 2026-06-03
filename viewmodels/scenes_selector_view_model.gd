@tool
class_name DH_CSR_ScenesSelectorViewModel
extends RefCounted

signal items_changed(items: Array[DH_CSR_SceneItemViewModel])
signal warning_changed(message: String)
signal scenes_saved

var _repository: DH_CSR_ScenesRepository
var _items: Array[DH_CSR_SceneItemViewModel] = []
var _warning_message: String = ""

func _init(repository: DH_CSR_ScenesRepository) -> void:
	_repository = repository
	for scene_data: DH_CSR_RunnerSceneData in _repository.load_scenes():
		_add_item(scene_data)
	_refresh_validation_warning()

func add_scene() -> void:
	_add_item(DH_CSR_RunnerSceneData.new())
	_persist()
	items_changed.emit(_items)

func get_items() -> Array[DH_CSR_SceneItemViewModel]:
	return _items

func get_warning_message() -> String:
	return _warning_message

func save_changes() -> void:
	_persist()

func _add_item(scene_data: DH_CSR_RunnerSceneData) -> void:
	var item_view_model: DH_CSR_SceneItemViewModel = DH_CSR_SceneItemViewModel.new(scene_data)
	item_view_model.changed.connect(_persist)
	item_view_model.remove_requested.connect(_on_item_remove_requested)
	item_view_model.shortcut_requested.connect(_on_item_shortcut_requested)
	_items.append(item_view_model)

func _on_item_remove_requested(item_view_model: DH_CSR_SceneItemViewModel) -> void:
	_items.erase(item_view_model)
	_persist()
	items_changed.emit(_items)

func _on_item_shortcut_requested(item_view_model: DH_CSR_SceneItemViewModel, key: Key) -> void:
	for item: DH_CSR_SceneItemViewModel in _items:
		if item != item_view_model and item.data.keyboard_shortcut == key:
			_set_warning("Shortcut already used by " + item.data.get_display_name() + ".")
			return
	item_view_model.set_shortcut(key)

func _persist() -> void:
	var scene_datas: Array[DH_CSR_RunnerSceneData] = []
	for item_view_model: DH_CSR_SceneItemViewModel in _items:
		scene_datas.append(item_view_model.data)
	_repository.save_scenes(scene_datas)
	_refresh_validation_warning()
	scenes_saved.emit()

func _refresh_validation_warning() -> void:
	for item_view_model: DH_CSR_SceneItemViewModel in _items:
		if not item_view_model.is_valid_scene():
			_set_warning("Some scene rows are incomplete or invalid.")
			return
	_set_warning("")

func _set_warning(message: String) -> void:
	_warning_message = message
	warning_changed.emit(_warning_message)
