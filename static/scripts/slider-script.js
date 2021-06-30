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
      }
    });
    $( "#target" ).html( $( "#slider" ).slider( "value" ) );
} );



function setAngle(angle){
    var angle_json = JSON.stringify(angle);
    $.post("/postmethod", {
        target_angle: angle_json
    });
}