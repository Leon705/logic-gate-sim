class_name InputClock
extends BaseGate

var spin_box: SpinBox;
var interval: float;
var timer: float = 0.0;

func _on_changed(value: float) -> void:
	interval = 1.0 / value;

func _compute(_inputs: Array[bool]) -> bool:
	return output_state;

func _process(delta: float) -> void:
	timer += delta;
	if timer >= interval:
		output_state = !output_state;
		_propagate_signal();
		timer -= interval;

func _get_slot_ui_component(_idx: int) -> Control:
	spin_box = SpinBox.new();
	spin_box.set_value_no_signal(0.0);
	spin_box.max_value = 20.0;
	spin_box.suffix = "Hz";
	spin_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL;
	spin_box.mouse_filter = MOUSE_FILTER_STOP;
	spin_box.value_changed.connect(_on_changed);
	return spin_box;
	
