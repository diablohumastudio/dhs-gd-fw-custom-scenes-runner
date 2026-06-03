@tool
class_name DH_CSR_SceneItem
extends HBoxContainer

var view_model: DH_CSR_SceneItemViewModel :
	set(view_model_):
		view_model = view_model_
		_render()

var _capturing_shortcut: bool = false

func _ready() -> void:
	set_process_unhandled_key_input(false)
	_render()

func _render() -> void:
	if not is_node_ready() or view_model == null:
		return
	%NameEdit.text = view_model.get_scene_name()
	%SceneButton.text = view_model.get_scene_label()
	%ShortcutButton.text = view_model.get_shortcut_label()
	modulate = Color(1.0, 1.0, 1.0) if view_model.is_valid_scene() else Color(1.0, 0.72, 0.72)

func _unhandled_key_input(event: InputEvent) -> void:
	if view_model == null or not _capturing_shortcut:
		return
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			_cancel_shortcut_capture()
			get_viewport().set_input_as_handled()
			return
		if _is_filtered_shortcut_key(event.keycode):
			return
		view_model.request_shortcut(event.keycode)
		%ShortcutButton.text = view_model.get_shortcut_label()
		_cancel_shortcut_capture()
		get_viewport().set_input_as_handled()

func _on_name_edit_text_changed(new_text: String) -> void:
	view_model.set_scene_name(new_text, false)

func _on_name_edit_focus_exited() -> void:
	view_model.commit_changes()
	_render()

func _on_scene_button_pressed() -> void:
	%FileDialog.popup_centered()

func _on_shortcut_button_pressed() -> void:
	_capturing_shortcut = true
	%ShortcutButton.text = "Press a key..."
	set_process_unhandled_key_input(true)

func _on_remove_button_pressed() -> void:
	_cancel_shortcut_capture()
	view_model.request_remove()

func _on_file_dialog_file_selected(path: String) -> void:
	view_model.set_scene_path(path)
	_render()

func _cancel_shortcut_capture() -> void:
	_capturing_shortcut = false
	set_process_unhandled_key_input(false)
	if is_node_ready() and view_model != null:
		%ShortcutButton.text = view_model.get_shortcut_label()

func _is_filtered_shortcut_key(key: Key) -> bool:
	return key == KEY_NONE or key == KEY_SHIFT or key == KEY_CTRL or key == KEY_ALT or key == KEY_META
