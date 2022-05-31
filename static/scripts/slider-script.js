$( function() {
    $( "#slider" ).slider({
      range: "min",
      min: 0,
      max: 90,
      value: 0,
      slide: function( event, ui ) {
        $( "#target" ).html( ui.value);
        console.log(ui.value);
        setAngle(ui.value);
      },
      change: function(event, ui){
        setSliderImg(ui.value);
      }
      
    });
    $( "#target" ).html( $( "#slider" ).slider( "value" ) );
} );



function setAngle(angle, button=false){
    var angle_json = JSON.stringify(angle);
    if(button){
      console.log("DOING THIS AND ITS FUCKING EVERYTHING UP");
      $("#slider").slider("value", angle);
    }
    setSliderImg(angle);
    $.post("/postmethod", {
        target_angle: angle_json
    });
}


function setSliderImg(angle){
	var back_opacity = (angle/90);
	var front_opacity = (1-back_opacity);
	$("#slider").css({'background-color':'rgba(255, 0, 0, '+front_opacity});

	//if i ever change the background colour from (44, 44, 44 this needs to be recalced)
	var r = ((back_opacity*255) + ((1-back_opacity)*44));
	var g = ((1-back_opacity)*44);
	var b = ((1-back_opacity)*44);
	console.log(r, g, b);

	$("#slider .ui-slider-range").css({'background-color':'rgb('+r+', '+g+', '+b+')'})
}