@tool
class_name DH_CSR_ScenesSelectorViewModel
extends RefCounted

## ViewModel for the scenes selector window. Owns the editable collection of row
## ViewModels and persists every change through the repository. No UI references.

signal items_changed(items: Array[DH_CSR_SceneItemViewModel])

var _repository: DH_CSR_ScenesRepository
var _items: Array[DH_CSR_SceneItemViewModel] = []

func _init(repository: DH_CSR_ScenesRepository) -> void:
	_repository = repository
	for scene_data: DH_CSR_RunnerSceneData in _repository.load_scenes():
		_add_item(scene_data)

func add_scene() -> void:
	_add_item(DH_CSR_RunnerSceneData.new())
	_persist()
	items_changed.emit(_items)

func _add_item(scene_data: DH_CSR_RunnerSceneData) -> void:
	var item_view_model: DH_CSR_SceneItemViewModel = DH_CSR_SceneItemViewModel.new(scene_data)
	item_view_model.changed.connect(_persist)
	item_view_model.remove_requested.connect(_on_item_remove_requested)
	_items.append(item_view_model)

func _on_item_remove_requested(item_view_model: DH_CSR_SceneItemViewModel) -> void:
	_items.erase(item_view_model)
	_persist()
	items_changed.emit(_items)

func _persist() -> void:
	var scene_datas: Array[DH_CSR_RunnerSceneData] = []
	for item_view_model: DH_CSR_SceneItemViewModel in _items:
		scene_datas.append(item_view_model.data)
	_repository.save_scenes(scene_datas)
