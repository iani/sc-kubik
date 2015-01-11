//:

Server.default.reboot;

Server.default.options.numOutputBusChannels = 43;

//:
Help.gui;

//:

Server.default.scope;

//:

~sound = { | out = 0 pos = 0 width = 2 orientation = 0 level = 1, rate = 1 |
	var source, pan;

	source = WhiteNoise.ar(0.1) * Decay2.kr(Impulse.kr(rate));
	pan = PanAz.ar(6, source, pos, level, width, orientation);
	Out.ar(out, pan);

}.play;

//:

~sound.set(\pos, 0.2);;

//:

~window = Window().front;

~window.view.layout = VLayout(
	~pos = Slider().background_(Color.red),
	~orientation = Slider()
);

//:
~pos.action = { | me |  ~sound.set(\pos, me.value * 2 - 1) };
~orientation.action = { | me |  ~sound.set(\orientation, (me.value * 6).postln) };
//:

//:

Help.gui;


//: Getting acquainted with PanAz
(
~test1 = { | out = 0 pos = 0 level = 1 width = 2 orientation = 0 rate = 1 |
	var source, pan;
	source = WhiteNoise.ar(0.1) * Decay2.kr(Impulse.kr(rate));
	pan = PanAz.ar(5, source, pos, level, width, orientation);
	Out.ar(out, pan);
}.play;
)

//: OSC
(
thisProcess.openUDPPort(5556);
OSCFunc.trace(false);

)


(
OSCdef('out', { | msg, time, addr, recvPort, argTemplate |
 	[msg, time, addr, recvPort].postln;
	msg[1].class.postln;
	~test0.set(\out, msg[1]);
}, '/out');

OSCdef('pos', { | msg, time, addr, recvPort, argTemplate |
 	[msg, time, addr, recvPort].postln;
	msg[1].class.postln;
	~test0.set(\pos, msg[1] / 1000 * 2 - 1);
}, '/pos');

OSCdef('level', { | msg, time, addr, recvPort, argTemplate |
 	[msg, time, addr, recvPort].postln;
	msg[1].class.postln;
	~test0.set(\level, msg[1] / 1000 * 3);
}, '/level');
)

// Code the above more compactly for speed and coding safety
(
~createOSCreceivers = { | messageSpecs |
	messageSpecs keysValuesDo: { | key func |
		[key, func].postln;
		OSCdef(key, { | msg |
			[msg].postln;
			~test1.set(key, func.(msg[1]));
		}, key)
	}
}
)

//:
(
~createOSCreceivers.(
	(
		out: { | val | (val / 1000 * 100).asInteger },
		pos: { | val | val / 1000 * 2 - 1 },
		level: { | val | val / 1000 * 3 })
)
)









