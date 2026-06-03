@tool
class_name DH_CustomScenesRunnerToolbar
extends PopupMenu

const SELECT_SCENES_ITEM_ID := 1

var _view_model: DH_CSR_ToolbarViewModel

func _enter_tree() -> void:
	set_meta("dhs_toolbar", true)
	if _view_model == null and DH_CustomScenesRunnerPlugin.instance:
		_view_model = DH_CustomScenesRunnerPlugin.instance.tool_bar_view_model
	if _view_model == null:
		return
	if not _view_model.scenes_changed.is_connected(_rebuild_menu):
		_view_model.scenes_changed.connect(_rebuild_menu)
	if not id_pressed.is_connected(_on_menu_id_pressed):
		id_pressed.connect(_on_menu_id_pressed)
	_view_model.reload()

func _rebuild_menu(scenes: Array[DH_CSR_RunnerSceneData]) -> void:
	clear()
	add_item("Select Scenes", SELECT_SCENES_ITEM_ID)
	add_separator()
	for ii in scenes.size():
		add_item("Run " + scenes[ii].get_display_name(), -1, scenes[ii].keyboard_shortcut)

func _on_menu_id_pressed(id: int) -> void:
	if id == SELECT_SCENES_ITEM_ID:
		_view_model.request_open_selector()
	else:
		_view_model.run_scene(id)
