@tool
class_name DH_CSR_ScenesRepository
extends RefCounted

const SCENES_PATH: String = "res://addons/diablohumastudio_framework/custom_scenes_runner/user_data/scenes.tres"

func load_scenes() -> Array[DH_CSR_RunnerSceneData]:
	if !ResourceLoader.exists(SCENES_PATH):
		DirAccess.make_dir_recursive_absolute(SCENES_PATH.get_base_dir())
		var create_error: Error = ResourceSaver.save(DH_CSR_RunnerScenes.new(), SCENES_PATH)
		if create_error != OK:
			push_error("CustomSceneRunner: Failed to create scenes resource: " + error_string(create_error))
			return []
	var resource: Resource = ResourceLoader.load(SCENES_PATH, "", ResourceLoader.CACHE_MODE_REPLACE)
	if not resource is DH_CSR_RunnerScenes:
		push_error("CustomSceneRunner: Invalid scenes resource: " + SCENES_PATH)
		return []
	var scenes_resource: DH_CSR_RunnerScenes = resource
	return scenes_resource.scenes

func save_scenes(scenes: Array[DH_CSR_RunnerSceneData]) -> void:
	var scenes_resource: DH_CSR_RunnerScenes = DH_CSR_RunnerScenes.new()
	scenes_resource.scenes = scenes
	var save_error: Error = ResourceSaver.save(scenes_resource, SCENES_PATH)
	if save_error != OK:
		push_error("CustomSceneRunner: Failed to save scenes resource: " + error_string(save_error))
