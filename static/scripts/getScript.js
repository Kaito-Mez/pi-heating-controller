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
	$("#duct-image").css({'transform': 'rotate('+angle+"deg)"});
}

getInit();
setCurrent();

i = 0;
setInterval(function() {
    i++;
    setCurrent();
}, 1000);


