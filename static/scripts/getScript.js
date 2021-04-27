var servo_output = document.getElementById('current');
var boxes = [servo_output]

async function getRequest(init=false) {
    func = await $.get("/getmethod", function(current_data) {
	return(current_data);
    });

    return func;
}

function setCurrent(fields) {
    getRequest().then((data) => {
	var dict = JSON.parse(data);
	console.log(dict)
	console.log(jQuery.type(dict))
	var slider = document.getElementById('servoAngle');
	var slider_val = document.getElementById('target');
	if (slider.innerHTML != dict["Target"]) {  	  
	    slider.value = dict["Target"];
	    slider_val.innerHTML = dict["Target"];
	}

	for(const field in fields) {
	    fields[field].innerHTML = dict["Current"];
	}
    });
}

setCurrent(boxes, 0, init=true);

i = 0;
setInterval(function() {
    i++;
    setCurrent(boxes);
}, 1000);


