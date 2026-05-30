@tool
class_name DH_CustomScenesRunnerToolbar
extends PopupMenu

## View: renders the scene list as menu items and routes input to the shared
## ViewModel. It does NOT open other views — "Select Scenes" is emitted as an
## intent on the ViewModel; the plugin coordinator handles the actual window.
##
## The ViewModel is fetched from the plugin singleton in _enter_tree (rather
## than injected) so the View survives the core toolbar's duplicate-and-relocate
## mechanism: _enter_tree re-runs on the clone and re-acquires the shared VM.

const SELECT_SCENES_ITEM_ID := 1000

var _view_model: DH_CSR_ToolbarViewModel

func _init(view_model_: DH_CSR_ToolbarViewModel) -> void:
	_view_model = view_model_

func _enter_tree() -> void:
	set_meta("dhs_toolbar", true)
	if not _view_model.scenes_changed.is_connected(_rebuild_menu):
		_view_model.scenes_changed.connect(_rebuild_menu)
	if not id_pressed.is_connected(_on_menu_id_pressed):
		id_pressed.connect(_on_menu_id_pressed)
	_view_model.reload()

func _rebuild_menu(scenes: Array[DH_CSR_RunnerSceneData]) -> void:
	clear()
	for ii in scenes.size():
		add_item("Run " + scenes[ii].name, ii, scenes[ii].keyboard_shortcut)
	add_separator()
	add_item("Select Scenes", SELECT_SCENES_ITEM_ID)

func _on_menu_id_pressed(id: int) -> void:
	if id == SELECT_SCENES_ITEM_ID:
		_view_model.request_open_selector()
	else:
		_view_model.run_scene(id)
