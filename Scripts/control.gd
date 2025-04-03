extends Control

# menu bar buttons
@onready var menu_bar: MenuBar = %MenuBar
@onready var file: PopupMenu = %File
@onready var edit: PopupMenu = %Edit
@onready var view: PopupMenu = %View
@onready var about: PopupMenu = %About
# main UI
@onready var tree: Tree = %Tree
@onready var text_edit: CodeEdit = %CodeEdit
@onready var note_renderer: MarkdownLabel = %NoteRenderer
# containers
@onready var sidebar_container: PanelContainer = %SidebarContainer
@onready var editor_container: PanelContainer = %EditorContainer
@onready var editor_tab_bar: TabBar = %EditorTabBar
@onready var new_tab_button: Button = %NewTabButton
@onready var renderer_container: PanelContainer = %RendererContainer

@onready var note_renderer_timer: Timer = %NoteRendererTimer
@onready var shader_overlay: ColorRect = %ShaderOverlay


const PLUS = preload("res://assets/plus.png")

func _ready() -> void:
	var root = tree.create_item()
	tree.hide_root = true
	var child1 = tree.create_item(root)
	child1.set_text(0, "notebook")
	var child2 = tree.create_item(root)
	child2.set_text(0, "notebook 2")
	#child2.set_button(0, 0,null)
	var subchild1 = tree.create_item(child1)
	subchild1.set_text(0, "Subchild1")
	subchild1.set_editable(0, true)
	var subchild2 = tree.create_item(child2)
	subchild2.set_text(0, "note 2 book 2")
	subchild2.set_editable(0, true)
	
	_render_text()
	note_renderer_timer.timeout.connect(_render_text)
	last_SHA256 = text_edit.text.sha256_text()
	
	#region File menu shortcuts
	var new_file_shortcut: Shortcut = Shortcut.new()
	var new_file_input_event: InputEventAction = InputEventAction.new()
	new_file_input_event.action = "new_file"
	new_file_shortcut.events.append(new_file_input_event)
	file.set_item_shortcut(0, new_file_shortcut, true)
	
	var new_notebook_shortcut: Shortcut = Shortcut.new()
	var new_notebook_input_event: InputEventAction = InputEventAction.new()
	new_notebook_input_event.action = "new_notebook"
	new_notebook_shortcut.events.append(new_notebook_input_event)
	file.set_item_shortcut(1, new_notebook_shortcut, true)
	
	#endregion File menu shortcuts
	
	#region View menu shortcuts 
	## shader shortcut
	var shader_shortcut: Shortcut = Shortcut.new()
	var shader_input_event: InputEventAction = InputEventAction.new()
	shader_input_event.action = "toggle_overlay"
	shader_shortcut.events.append(shader_input_event)
	view.set_item_shortcut(0, shader_shortcut, true)
	
	## sidebar shortcut
	var sidebar_shortcut: Shortcut = Shortcut.new()
	var sidebar_input_event: InputEventAction = InputEventAction.new()
	sidebar_input_event.action = "toggle_sidebar"
	sidebar_shortcut.events.append(sidebar_input_event)
	view.set_item_shortcut(1, sidebar_shortcut, true)
	
	
	#endregion View menu shortcuts 
	
	
	text_edit.grab_focus()
	
	var plus_texture: Texture2D = PLUS
	


func _on_tree_column_title_clicked(column: int, _mouse_button_index: int) -> void:
	var item_name = tree.get_column_title(column)
	print(item_name + "🔥")


func _on_tree_item_edited() -> void:
	print("an item has been edited 🔥")

var last_SHA256: String = ""
func _render_text() -> void:
	if note_renderer.visible:
		if last_SHA256 != text_edit.text.sha256_text():
			note_renderer.markdown_text = text_edit.text


func _on_code_edit_text_changed() -> void:
	_render_text()


func _on_view_id_pressed(id: int) -> void:
	match id:
		11:
			shader_overlay.visible = !shader_overlay.visible
		0:
			tree.visible = !tree.visible
			#view.set_item_checked()


func _on_view_index_pressed(index: int) -> void:
	match index:
		0:
			shader_overlay.visible = !shader_overlay.visible
			view.set_item_checked(0, shader_overlay.visible)
		1:
			sidebar_container.visible = !sidebar_container.visible
			view.set_item_checked(1, sidebar_container.visible)
		2:
			menu_bar.visible = !menu_bar.visible
			view.set_item_checked(2, menu_bar.visible)
		3:
			renderer_container.visible = !renderer_container.visible
			view.set_item_checked(3, renderer_container.visible)
		5:
			text_edit.gutters_draw_line_numbers = !text_edit.gutters_draw_line_numbers
			view.set_item_checked(5, text_edit.gutters_draw_line_numbers)
		6:
			text_edit.highlight_current_line = !text_edit.highlight_current_line
			view.set_item_checked(6, text_edit.highlight_current_line)
		7:
			if text_edit.wrap_mode == TextEdit.LINE_WRAPPING_NONE:
				text_edit.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
				view.set_item_checked(7, true)
			else:
				text_edit.wrap_mode = TextEdit.LINE_WRAPPING_NONE
				view.set_item_checked(7, false)
		8:
			text_edit.minimap_draw = !text_edit.minimap_draw
			view.set_item_checked(8, text_edit.minimap_draw)



#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("toggle_overlay"):
		#shader_overlay.visible = !shader_overlay.visible
		#view.set_item_checked(0, shader_overlay.visible)


func _on_file_id_pressed(id: int) -> void:
	match id:
		0:
			editor_container.add_child(CodeEdit.new())
