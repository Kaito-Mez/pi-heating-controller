//server to client

async function getRequest() {
    func = await $.get("/getmethod", function(current_data) {
	return(current_data);
    });

    return func;
}
async function getInit() {
	$.get("/getmethod", function(initdata){
        console.log(initdata);
		initdata = JSON.parse(initdata);
		$("#target").html(initdata["target"]);
		$("#slider").slider("value", initdata["target"]);
		setImages(initdata["current"]);
	})
}

function setCurrent() {
    getRequest().then((data) => {
	var dict = JSON.parse(data);
	if($("#slider").slider("value") != dict["target"]){
		$("#slider").slider("value", dict["target"]);
		$("#target").html(dict["target"]);
		setSliderImg(dict["target"]);
	}
	if($("#current").html() != dict["current"]){
		$("#current").html(dict["current"]);
		setImages(dict["current"]);
	}
    });
}


//make overlap image that rotates every time it changes
function setImages(angle){
	$("#duct-image").css({'transform': 'rotate('+(90-angle)+"deg)"});
	var back_opacity = ((angle/90)*100)/100;
	var front_opacity = (1-back_opacity);
	$("#back").css({'opacity': back_opacity});
	$("#front").css({'opacity': front_opacity});
}


getInit();


setInterval(function() {
	//make this so that the python side is initiating this
    setCurrent();
}, 500);


