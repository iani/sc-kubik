var socket = io();


jQuery(document).ready(function ($) {

    oscSlider("x");

    oscSlider("y");

    oscSlider("xwidth");

    oscSlider("ywidth");

    oscSlider("level");

    socket.on('users', function (msg) {
        console.log("Clients: " + msg);
    });

    socket.on('osc', function (msg) {
        console.log(msg);
    });

});


function oscSlider(oscPath, min, max) {

   min = min || 0;
   max = max || 1;

   var resolution = 1000;

   var UImin = min * resolution;
   var UImax = max * resolution;


    $('<label>')
        .attr('for',oscPath)
        .text(oscPath)
        .appendTo('.controllers');

    $('<input>')
        .attr('class',oscPath)
        .attr('id',oscPath)
        .attr('type','range')
        .attr('min',UImin)
        .attr('max',UImax)
        .appendTo('.controllers');


    $('.' + oscPath).rangeslider({
        polyfill: false,
        onSlide: function(position, value) {
            var value = new Number(value);
            var msg = {
                address: '/' + oscPath,
                args: [
                    value / resolution
                ]
            };
            socket.emit('osc', msg);

            $('label[for=' + oscPath + ']').text(oscPath + ' ' + value / resolution);
        }
    });


    //missing bidirectional control
}
