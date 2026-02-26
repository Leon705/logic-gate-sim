extends FileDialog
class_name DefaultExportDialog

func _ready() -> void:
	add_filter("*.json", "JSON Files")
