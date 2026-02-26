var input = document.createElement('input');
input.type = 'file';
input.accept = '.json';

input.onchange = function(event) {
	var file = event.target.files[0];
	if (!file) return;
	
	var reader = new FileReader();
	reader.onload = function(e) {
		window.godot_upload_callback(e.target.result);
	};
	reader.readAsText(file);
};

input.click();
