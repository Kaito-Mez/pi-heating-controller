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
	if($("#current").html() != dict["Current"]){
		$("#current").html(dict["Current"]);
		setImages(dict["Current"]);
	}
	if($("#slider").slider("value") != dict["Target"]){
		$("#slider").slider("value", dict["Target"]);
		$("#target").html(dict["Target"]);
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
	$("#slider").css({'background-color':'rgba(255, 0, 0, '+front_opacity});

	
	//if i ever change the background colour from (44, 44, 44 this needs to be recalced)
	var r = ((back_opacity*255) + ((1-back_opacity)*44));
	var g = ((1-back_opacity)*44);
	var b = ((1-back_opacity)*44);
	console.log(r, g, b);

	$("#slider .ui-slider-range").css({'background-color':'rgb('+r+', '+g+', '+b+')'})
}
getInit();


setInterval(function() {
	//make this so that the python side is initiating this
    setCurrent();
}, 500);


