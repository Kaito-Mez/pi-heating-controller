var slider = document.getElementById("servoAngle");
var output = document.getElementById("target");

var output_float = parseFloat(slider.value);

var servo_details = new Object();

output.innerHTML = slider.value;

servo_details = {
	"Target":output_float
}

function postTarget(){
	var servo_json = JSON.stringify(servo_details);
	$.post( "/postmethod", {
		servo_data: servo_json
	});
}

slider.oninput = function() {
	output.innerHTML = this.value;
	servo_details["Target"] = parseFloat(this.value);
	postTarget();
}
