@tool
class_name DH_CustomScenesRunnerToolbar
extends PopupMenu

const SELECT_SCENES_ITEM_ID := 1000

const SELECT_SCENES_POPUP_PKSC: PackedScene = preload("uid://dlfttbd1xdwe8")
var scenes: Array[DH_CSR_RunnerSceneData] = []
var saved_scenes_resource_path: String:
	get:
		return "res://dh_csr/scenes.tres"

func _enter_tree() -> void:
	set_meta("dhs_toolbar", true)
	_load_scenes()
	_rebuild_menu()
	id_pressed.connect(_on_menu_id_pressed)

func _load_scenes():
	if !ResourceLoader.exists(saved_scenes_resource_path):
		DirAccess.make_dir_recursive_absolute(saved_scenes_resource_path.get_base_dir())
		ResourceSaver.save(DH_CSR_RunnerScenes.new(), saved_scenes_resource_path)
	var scenes_resource: DH_CSR_RunnerScenes = ResourceLoader.load(saved_scenes_resource_path, "", ResourceLoader.CACHE_MODE_REPLACE)
	scenes = scenes_resource.scenes

func _rebuild_menu() -> void:
	clear()
	for ii in scenes.size():
		add_item("Run " + scenes[ii].name, ii, scenes[ii].keyboard_shortcut)
	add_separator()	
	add_item("Select Scenes", SELECT_SCENES_ITEM_ID)

func _on_menu_id_pressed(id: int) -> void:
	if id == SELECT_SCENES_ITEM_ID:
		var select_scenes_popup_instance: DH_CSR_ScenesSelector = SELECT_SCENES_POPUP_PKSC.instantiate()
		select_scenes_popup_instance.saved_scenes_resource_path = saved_scenes_resource_path
		select_scenes_popup_instance.scenes_updated.connect(_on_scenes_updated)
		EditorInterface.get_base_control().add_child(select_scenes_popup_instance)
		select_scenes_popup_instance.popup_centered()
	else:
		if id < scenes.size():
			EditorInterface.play_custom_scene(scenes[id].scene_path)

func _on_scenes_updated() -> void:
	_load_scenes()
	_rebuild_menu()
