tool
extends EditorPlugin


const MainView = preload("res://addons/puzzle_dependencies/views/main_view.tscn")


var main_view


func _enter_tree() -> void:
	if Engine.editor_hint:
		main_view = MainView.instance()
		get_editor_interface().get_editor_viewport().add_child(main_view)
		main_view.plugin = self
		main_view.undo_redo = get_undo_redo()
		make_visible(false)


func _exit_tree() -> void:
	if is_instance_valid(main_view):
		main_view.queue_free()
		

func has_main_screen() -> bool:
	return true


func make_visible(next_visible: bool) -> void:
	if is_instance_valid(main_view):
		main_view.visible = next_visible


func get_plugin_name() -> String:
	return "Puzzles"


func get_plugin_icon() -> Texture:
	var base_color = get_editor_interface().get_editor_settings().get_setting("interface/theme/base_color")
	var theme = "light" if base_color.v > 0.5 else "dark"
	var base_icon = load("res://addons/puzzle_dependencies/assets/icons/icon_%s.svg" % [theme]) as Texture
	
	var size = get_editor_interface().get_editor_viewport().get_icon("Godot", "EditorIcons").get_size()
	var image: Image = base_icon.get_data()
	image.resize(size.x, size.y, Image.INTERPOLATE_TRILINEAR)
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	return texture
	

func apply_changes() -> void:
	if is_instance_valid(main_view):
		main_view.apply_changes()
