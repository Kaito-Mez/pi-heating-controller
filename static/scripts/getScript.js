//server to client

async function getRequest() {
    func = await $.get("/getmethod", function(current_data) {
	return(current_data);
    });

    return func;
}
async function getInit() {
	$.get("/getmethod", function(initdata){
		initdata = JSON.parse(initdata);
		$("#target").html(initdata["Target"]);
		$("#slider").slider("value", initdata["Target"]);
		setImages(initdata["Current"]);
	})
}

function setCurrent() {
    getRequest().then((data) => {
	var dict = JSON.parse(data);
	var change = 0;
	if($("#current").html() != dict["Current"]){
		$("#current").html(dict["Current"]);
		setImages(dict["Current"]);
	}
	if($("#slider").slider("value") != dict["Target"]){
		console.log("START");
		setTimeout(function(){
			console.log("EXE")
			if($("#slider").slider("value") != dict["Target"]){
				$("#slider").slider("value", dict["Target"]);
				$("#target").html(dict["Target"]);
				setSliderImg(dict["Target"]);
			}
		}, 500);
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


