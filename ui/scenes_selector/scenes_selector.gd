@tool
class_name DH_CSR_ScenesSelector
extends Window

signal scenes_updated

var item_scene: PackedScene = preload("uid://70e3ag4jq3k6")
var view_model: DH_CSR_ScenesSelectorViewModel

func _ready() -> void:
	if not view_model:
		return
	view_model.items_changed.connect(_render)
	view_model.warning_changed.connect(_on_warning_changed)
	view_model.scenes_saved.connect(_on_scenes_saved)
	_render(view_model.get_items())
	_on_warning_changed(view_model.get_warning_message())

func _on_add_button_pressed() -> void:
	view_model.add_scene()

func _on_close_requested() -> void:
	view_model.save_changes()
	queue_free()

func _render(items: Array[DH_CSR_SceneItemViewModel]) -> void:
	for child in %ItemsContainer.get_children():
		child.queue_free()
	for itemview_model: DH_CSR_SceneItemViewModel in items:
		var new_item: DH_CSR_SceneItem = item_scene.instantiate()
		new_item.view_model = itemview_model
		%ItemsContainer.add_child(new_item)
	scenes_updated.emit()

func _on_warning_changed(message: String) -> void:
	%WarningLabel.text = message
	%WarningLabel.visible = not message.is_empty()

func _on_scenes_saved() -> void:
	scenes_updated.emit()
