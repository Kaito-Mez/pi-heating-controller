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
	if(angle<30){
		$("#duct-image").attr("src", "/static/images/0.png");
	}
	else if(angle<60){
		$("#duct-image").attr("src", "/static/images/45.png");
	}
	else{
		$("#duct-image").attr("src", "/static/images/90.png");
	}
}

getInit();
setCurrent();

i = 0;
setInterval(function() {
    i++;
    setCurrent();
}, 1000);


