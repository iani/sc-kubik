var socket = io();

jQuery(document).ready(function ($) {

    socket.on('users', function (msg) {
        console.log("Clients: " + msg)
    });

    socket.on('osc', function (msg) {
        console.log(msg)
    });

    $(".sound").mouseup(function () {
        var value = new Number($(this).val());
        var msg = {
            address: "/browser", 
            args: [
                value
            ]
        };
        socket.emit('osc', msg);    
    });


});


