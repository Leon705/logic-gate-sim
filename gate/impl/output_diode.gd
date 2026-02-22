class_name OutputDiode
extends BaseGate

var style: StyleBoxFlat;

func _ready() -> void:
	super();
	style = get_theme_stylebox("panel").duplicate();
	add_theme_stylebox_override("panel", style);
	add_theme_stylebox_override("panel_selected", style);
	_update_visuals();
	
func _compute(inputs: Array[bool]) -> bool:
	return inputs[0] if inputs.size() > 0 else false;

func _update_visuals():
	style.bg_color = Color.RED if output_state else Color(0.1, 0, 0);
