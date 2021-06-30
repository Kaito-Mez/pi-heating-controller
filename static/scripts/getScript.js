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
	$("#current").html(dict["Current"]);
	setImages(dict["Current"]);
    });
}


//make overlap image that rotates every time it changes
function setImages(angle){
	$("#duct-image").css({'transform': 'rotate('+(90-angle)+"deg)"});
	var back_opacity = ((angle/90)*100)/100;
	var front_opacity = (1-back_opacity);
	console.log(front_opacity);
	$("#back").css({'opacity': back_opacity});
	$("#front").css({'opacity': front_opacity});
	$("#slider").css({'background-color':'rgba(255, 0, 0, '+back_opacity});

	
	//if i ever change the background colour from (44, 44, 44 this needs to be recalced)
	var r = ((front_opacity*255) + ((1-front_opacity)*44));
	var g = ((1-front_opacity)*44);
	var b = ((1-front_opacity)*44);
	console.log(r, g, b);

	$("#slider .ui-slider-range").css({'background-color':'rgb('+r+', '+g+', '+b+')'})
}

getInit();
setCurrent();

i = 0;
setInterval(function() {
    i++;
    setCurrent();
}, 1000);


