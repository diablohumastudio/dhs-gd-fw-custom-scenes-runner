@tool
class_name DH_CSR_ScenesRepository
extends RefCounted

## Model layer: single owner of the on-disk scenes resource. All persistence
## (path, load, save, dir creation) lives here so views/viewmodels never touch
## ResourceLoader/ResourceSaver directly.

const SCENES_PATH: String = "res://addons/diablohumastudio_framework/custom_scenes_runner/user_data/scenes.tres"

func load_scenes() -> Array[DH_CSR_RunnerSceneData]:
	if !ResourceLoader.exists(SCENES_PATH):
		DirAccess.make_dir_recursive_absolute(SCENES_PATH.get_base_dir())
		ResourceSaver.save(DH_CSR_RunnerScenes.new(), SCENES_PATH)
	var scenes_resource: DH_CSR_RunnerScenes = ResourceLoader.load(SCENES_PATH, "", ResourceLoader.CACHE_MODE_REPLACE)
	return scenes_resource.scenes

func save_scenes(scenes: Array[DH_CSR_RunnerSceneData]) -> void:
	var scenes_resource: DH_CSR_RunnerScenes = DH_CSR_RunnerScenes.new()
	scenes_resource.scenes = scenes
	ResourceSaver.save(scenes_resource, SCENES_PATH)
