class_name GateCreator
extends PanelContainer

@onready var type_id_edit: LineEdit = $HBoxContainer/VBoxContainer/VBoxContainer/type_id;
@onready var title_edit: LineEdit = $HBoxContainer/VBoxContainer/VBoxContainer/title;
@onready var num_inputs: SpinBox = $HBoxContainer/VBoxContainer/VBoxContainer/num_inputs;
@onready var num_outputs: SpinBox =  $HBoxContainer/VBoxContainer/VBoxContainer/num_outputs;;

@onready var exit_button: Button = $HBoxContainer/VBoxContainer/VBoxContainer2/Button;
@onready var save_button: Button = $HBoxContainer/VBoxContainer/VBoxContainer2/Button2;
@onready var code_edit: CodeEdit = $HBoxContainer/CodeEdit;

signal closed;

func _ready() -> void:
	save_button.connect("pressed", _on_button_save_pressed);
	exit_button.connect("pressed", _on_button_exit_pressed)

func _on_button_exit_pressed() -> void:
	closed.emit();

func _on_button_save_pressed() -> void:
	var raw_id = type_id_edit.text.strip_edges().replace(" ", "_");
	var validated_id = raw_id.validate_filename();
	
	if validated_id.is_empty():
		print("ERROR: faulty ID");
		return;

	var base_dir = "user://gates/";
	if not DirAccess.dir_exists_absolute(base_dir):
		DirAccess.make_dir_recursive_absolute(base_dir);

	var script_path = base_dir + validated_id + ".gd";
	var res_path = base_dir + validated_id + ".tres";

	var file = FileAccess.open(script_path, FileAccess.WRITE)
	if file:
		var final_code = code_edit.text;
		file.store_string(final_code);
		file.close();
	else:
		print("ERROR: could not save script");
		return;

	var gate_def = GateDefinition.new();
	gate_def.type_id = validated_id;
	gate_def.title = title_edit.text;
	gate_def.num_inputs = int(num_inputs.value);
	gate_def.num_outputs = int(num_outputs.value);
	
	var loaded_script = load(script_path);
	gate_def.gate_script = loaded_script;
	
	var res_error = ResourceSaver.save(gate_def, res_path);
	
	if res_error == OK:
		print("ERFOLG: Gatter gespeichert unter ", res_path);
		await get_tree().create_timer(0.5).timeout;
		GateFactory.load_definitions("user://gates/");
		hide();
	else:
		print("ERROR beim Speichern der Resource: ", res_error);
	closed.emit();
