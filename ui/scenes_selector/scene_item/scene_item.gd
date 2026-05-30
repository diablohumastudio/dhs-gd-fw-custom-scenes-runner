@tool
class_name DH_CSR_SceneItem
extends HBoxContainer

## View: one editable row bound to a DH_CSR_SceneItemViewModel. Renders from the
## ViewModel and forwards user input to its commands.

var view_model: DH_CSR_SceneItemViewModel :
	set(view_model_):
		view_model = view_model_
		_render()

func _ready() -> void:
	set_process_unhandled_key_input(false)
	_render()

func _render() -> void:
	if not is_node_ready() or view_model == null:
		return
	%NameEdit.text = view_model.get_scene_name()
	%SceneButton.text = view_model.get_scene_label()
	%ShortcutButton.text = view_model.get_shortcut_label()

func _unhandled_key_input(event: InputEvent) -> void:
	if view_model == null or not view_model.capturing_shortcut:
		return
	if event is InputEventKey and event.pressed:
		view_model.set_shortcut(event.keycode)
		%ShortcutButton.text = view_model.get_shortcut_label()
		set_process_unhandled_key_input(false)

func _on_name_edit_text_changed(new_text: String) -> void:
	view_model.set_scene_name(new_text)

func _on_scene_button_pressed() -> void:
	%FileDialog.popup_centered()

func _on_shortcut_button_pressed() -> void:
	view_model.begin_capture_shortcut()
	%ShortcutButton.text = "Press a key..."
	set_process_unhandled_key_input(true)

func _on_remove_button_pressed() -> void:
	view_model.request_remove()

func _on_file_dialog_file_selected(path: String) -> void:
	view_model.set_scene_path(path)
	%SceneButton.text = view_model.get_scene_label()
