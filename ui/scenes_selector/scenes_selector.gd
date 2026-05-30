@tool
class_name DH_CSR_ScenesSelector
extends Window

## View: renders one row per item ViewModel and forwards button input to the
## ViewModel. Owns no scene collection or persistence logic.

signal scenes_updated

var item_scene: PackedScene = preload("uid://70e3ag4jq3k6")
var view_model: DH_CSR_ScenesSelectorViewModel

func _ready() -> void:
	view_model.items_changed.connect(_render)
	_render(view_model._items)

func _on_add_button_pressed() -> void:
	view_model.add_scene()

func _on_close_requested() -> void:
	queue_free()

func _render(items: Array[DH_CSR_SceneItemViewModel]) -> void:
	for child in %ItemsContainer.get_children():
		child.queue_free()
	for itemview_model: DH_CSR_SceneItemViewModel in items:
		var new_item: DH_CSR_SceneItem = item_scene.instantiate()
		new_item.view_model = itemview_model
		print(itemview_model.get_scene_name())
		%ItemsContainer.add_child(new_item)
	scenes_updated.emit()
