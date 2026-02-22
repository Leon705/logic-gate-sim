class_name xor_gate
extends BaseGate

func _compute(inputs: Array[bool]) -> bool:
	return inputs[0] != inputs[1];
