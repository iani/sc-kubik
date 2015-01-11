var socket = io();


jQuery(document).ready(function ($) {

    oscSlider("out", 0, 1000);

    oscSlider("pos", 0, 1000);

    oscSlider("level", 0, 1000);
    

    socket.on('users', function (msg) {
        console.log("Clients: " + msg)
    });

    socket.on('osc', function (msg) {
        console.log(msg)
    });

});


function oscSlider(oscPath, min, max) {

    $('<label>')
        .attr('for',oscPath)
        .text(oscPath)
        .appendTo('.controllers');

    $('<input>')
        .attr('class',oscPath)
        .attr('id',oscPath)
        .attr('type','range')
        .attr('min',min)
        .attr('max',max)
        .appendTo('.controllers');


    $('.' + oscPath).rangeslider({
        polyfill: false,
        onSlide: function(position, value) {
            var value = new Number(value);
            var msg = {
                address: '/' + oscPath,
                args: [
                    value
                ]
            };
            socket.emit('osc', msg);

            $('label[for=' + oscPath + ']').text(oscPath + ' ' + value);
        }
    });

    //missing bidirectional control
}
