class_name Main
extends Control

@onready var graph_edit: Editor = $GraphEdit;
@onready var ui_overlay_container: Control = $UiOverlayContainer;

const gate_creator_scene: PackedScene = preload("res://gate_creator/gate_creator.tscn");
const web_export_dialog_scene: PackedScene = preload("res://dialog/web_export_dialog.tscn");
const default_export_dialog_scene: PackedScene = preload("res://dialog/default_export_dialog.tscn");
const default_import_dialog_scene: PackedScene = preload("res://dialog/default_import_dialog.tscn");

var should_render_overlay: bool = true;

func _ready() -> void:
	GateFactory.load_definitions_from_manifest();
	GateFactory.load_definitions("user://gates/");
	
	if OS.has_feature("web"):
		var js_upload_callback = JavaScriptBridge.create_callback(_on_web_import_dialog_confirmed);
		JavaScriptBridge.get_interface("window").godot_upload_callback = js_upload_callback;
	
func _handle_gate_creator() -> void:
	graph_edit.hide();
	ui_overlay_container.hide();
	
	var instance: GateCreator = gate_creator_scene.instantiate();
	add_child(instance);
	await instance.closed;
	instance.queue_free();
	
	graph_edit.show();
	ui_overlay_container.visible = should_render_overlay;
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("gate_creator") and graph_edit.visible:
			_handle_gate_creator()
		elif event.is_action_pressed("toggle_info"):
			should_render_overlay =! should_render_overlay;
			ui_overlay_container.visible = should_render_overlay;
		elif event.is_action_pressed("save"):
			_handle_save_project();
		elif event.is_action_pressed("load"):
			_handle_load_project();
			
func _handle_load_project():
	if OS.has_feature("web"):
		var js_file = FileAccess.open("res://js/web_import_dialog.js", FileAccess.READ);	
		var js_content: String = js_file.get_as_text();
		JavaScriptBridge.eval(js_content);
	else:
		var dialog: DefaultImportDialog = default_import_dialog_scene.instantiate();
		add_child(dialog);
		dialog.file_selected.connect(_on_default_import_dialog_confirmed);
		dialog.canceled.connect(dialog.queue_free);
		dialog.popup_centered();
		
func _handle_save_project():
	if OS.has_feature("web"):
		var dialog := web_export_dialog_scene.instantiate();
		add_child(dialog);
		dialog.confirmed.connect(_on_web_export_dialog_confirmed.bind(dialog));
		dialog.canceled.connect(dialog.queue_free);
		dialog.popup_centered();
	else:
		var dialog : DefaultExportDialog = default_export_dialog_scene.instantiate();
		add_child(dialog);
		dialog.file_selected.connect(_on_default_export_dialog_confirmed);
		dialog.canceled.connect(dialog.queue_free);
		dialog.popup_centered();

func _on_default_export_dialog_confirmed(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE);
	if file:
		file.store_string(graph_edit.to_json());
		file.close();

func _on_web_export_dialog_confirmed(dialog: WebExportDialog) -> void:
	var filename = dialog.file_name_edit.text;
	if filename.is_empty():
		filename = "untitled_export.json";
	
	if !filename.ends_with(".json"):
		filename += ".json";

	JavaScriptBridge.download_buffer(
		graph_edit.to_json().to_utf8_buffer(), filename, "application/json");

func _on_web_import_dialog_confirmed(args: Array):
	var json_str = args[0];
	graph_edit.load_json(json_str);
	
func _on_default_import_dialog_confirmed(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ);
	if file:
		var json_str = file.get_as_text();
		graph_edit.load_json(json_str);
