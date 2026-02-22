class_name InputSwitch
extends BaseGate

var check_button: CheckButton;

func _on_toggled(is_on: bool) -> void:
	check_button.text = "ON" if is_on else "OFF";
	output_state = is_on;
	_propagate_signal();
	_update_visuals();

func _compute(_inputs: Array[bool]) -> bool:
	return output_state;

func _get_slot_ui_component(_idx: int) -> Control:
	check_button = CheckButton.new();
	check_button.text = "OFF";
	
	check_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL;
	check_button.mouse_filter = MOUSE_FILTER_STOP;
	check_button.toggled.connect(_on_toggled);
	return check_button;
	
