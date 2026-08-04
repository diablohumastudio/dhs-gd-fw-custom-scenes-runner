@tool
class_name DH_CustomScenesRunnerPlugin
extends EditorPlugin

const TOOLBAR_MENU_NAME: String = "CustomSceneRunner"
const FRAMEWORK_TOOLBAR_PATH: String = "res://addons/diablohumastudio_framework/core/main_toolbar_plugin/main_toolbar_plugin.gd"
const SELECT_SCENES_POPUP_PKSC: PackedScene = preload("uid://dlfttbd1xdwe8")

static var instance: DH_CustomScenesRunnerPlugin

var tool_bar_view_model: DH_CSR_ToolbarViewModel

var _scenes_repository: DH_CSR_ScenesRepository
var _selector: DH_CSR_ScenesSelector

func _enter_tree() -> void:
	instance = self
	_scenes_repository = DH_CSR_ScenesRepository.new()
	add_toolbar_menu()

func add_toolbar_menu() -> void:
	var tool_bar_menu: DH_CustomScenesRunnerToolbar = DH_CustomScenesRunnerToolbar.new()
	tool_bar_view_model = DH_CSR_ToolbarViewModel.new(_scenes_repository)
	tool_bar_view_model.open_selector_requested.connect(_open_scenes_selector)

	# Its loaded and checked instead of DH_MainToolbarPlugin.add_toolbar_submenu(TOOLBAR_MENU_NAME, tool_bar_menu, self), 
	# because it can be used without the main toolbar (if you dont have it class_name is not registered)
	if ResourceLoader.exists(FRAMEWORK_TOOLBAR_PATH):
		load(FRAMEWORK_TOOLBAR_PATH).add_toolbar_submenu(TOOLBAR_MENU_NAME, tool_bar_menu, self)
	else:
		add_tool_submenu_item(TOOLBAR_MENU_NAME, tool_bar_menu)

func _open_scenes_selector() -> void:
	if is_instance_valid(_selector):
		_selector.popup_centered()
		_selector.grab_focus()
		return
	_selector = SELECT_SCENES_POPUP_PKSC.instantiate()
	_selector.scenes_updated.connect(tool_bar_view_model.reload)
	_selector.tree_exited.connect(_on_selector_tree_exited)
	_selector.view_model = DH_CSR_ScenesSelectorViewModel.new(_scenes_repository)
	EditorInterface.get_base_control().add_child(_selector)
	_selector.popup_centered()

func _on_selector_tree_exited() -> void:
	_selector = null

func _exit_tree() -> void:
	if is_instance_valid(_selector):
		_selector.queue_free()
	if ResourceLoader.exists(FRAMEWORK_TOOLBAR_PATH):
		load(FRAMEWORK_TOOLBAR_PATH).remove_toolbar_submenu(TOOLBAR_MENU_NAME, self)
	else:
		remove_tool_menu_item(TOOLBAR_MENU_NAME)
	if instance == self:
		instance = null
