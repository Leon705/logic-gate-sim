extends FileDialog
class_name DefaultImportDialog

func _ready() -> void:
	add_filter("*.json", "JSON Files")
