@tool
class_name DH_CustomScenesRunnerPlugin
extends EditorPlugin

## Coordinator / composition root. Owns the toolbar ViewModel, creates the
## toolbar view, and performs navigation (opening the scenes selector window) in
## response to the ViewModel's intent signal. Exposed as a singleton so the
## toolbar view can re-acquire the shared VM after the core toolbar clones it.

const TOOLBAR_MENU_NAME: String = "CustomSceneRunner"
const _CORE_PATH: String = "res://addons/diablohumastudio_framework/core/main_toolbar_plugin/main_toolbar_plugin.gd"
const SELECT_SCENES_POPUP_PKSC: PackedScene = preload("uid://dlfttbd1xdwe8")

var tool_bar_view_model: DH_CSR_ToolbarViewModel

var _scenes_repository: DH_CSR_ScenesRepository

func _enter_tree() -> void:
	_scenes_repository = DH_CSR_ScenesRepository.new()
	add_toolbar_menu()

func add_toolbar_menu() -> void:
	tool_bar_view_model = DH_CSR_ToolbarViewModel.new()
	tool_bar_view_model.open_selector_requested.connect(_open_scenes_selector)
	var tool_bar_menu: DH_CustomScenesRunnerToolbar = DH_CustomScenesRunnerToolbar.new(tool_bar_view_model)

	if ResourceLoader.exists(_CORE_PATH):
		load(_CORE_PATH).add_toolbar_submenu(TOOLBAR_MENU_NAME, tool_bar_menu, self)
	else:
		add_tool_submenu_item(TOOLBAR_MENU_NAME, tool_bar_menu)

func _open_scenes_selector() -> void:
	var selector: DH_CSR_ScenesSelector = SELECT_SCENES_POPUP_PKSC.instantiate()
	selector.scenes_updated.connect(tool_bar_view_model.reload) # When you change the scenes in the popup, the toolbar gets auto updated
	selector.view_model = DH_CSR_ScenesSelectorViewModel.new(_scenes_repository)
	EditorInterface.get_base_control().add_child(selector)
	selector.popup_centered()

func _exit_tree() -> void:
	if ResourceLoader.exists(_CORE_PATH):
		load(_CORE_PATH).remove_toolbar_submenu(TOOLBAR_MENU_NAME, self)
	else:
		remove_tool_menu_item(TOOLBAR_MENU_NAME)
