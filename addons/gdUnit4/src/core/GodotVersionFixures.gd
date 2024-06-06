## This service class contains helpers to wrap Godot functions and handle them carefully depending on the current Godot version
class_name GodotVersionFixures
extends RefCounted


@warning_ignore("shadowed_global_identifier")
static func type_convert(value: Variant, type: int) -> Variant:
	return convert(value, type)


@warning_ignore("shadowed_global_identifier")
static func convert(value: Variant, type: int) -> Variant:
	return type_convert(value, type)


# handle global_position fixed by https://github.com/godotengine/godot/pull/88473
static func set_event_global_position(event: InputEventMouseMotion, global_position: Vector2) -> void:
	if Engine.get_version_info().hex >= 0x40202 or Engine.get_version_info().hex == 0x40104:
		event.global_position = event.position
	else:
		event.global_position = global_position


# we crash on macOS when using free() inside the plugin _exit_tree
static func free_fix(instance: Object) -> void:
	var distribution_name := OS.get_distribution_name()
	if distribution_name != "Windows":
		prints("Using queue_free() hotfix on system:", distribution_name)
		instance.queue_free()
	else:
		instance.free()
