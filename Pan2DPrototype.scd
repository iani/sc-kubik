//:

Server.default.reboot;

Server.default.options.numOutputBusChannels = 43;

//:
Help.gui;

//:

Server.default.scope;

//: Getting acquainted with PanAz
(
~test1 = { | out = 0 pos = 0 level = 1 width = 0 orientation = 0 rate = 1 |
	var source, pan;
	source = WhiteNoise.ar(0.1) * Decay2.kr(Impulse.kr(rate));
	pan = PanAz.ar(10, source, pos * 0.8, level, width * 8 + 2, orientation);
	Out.ar(out, pan);
}.play;
)

~test1.set(\orientation, 0, \pos, 0);
~test1.set(\pos, 1);
~test1.set(\width, 1);

//: OSC
(
thisProcess.openUDPPort(5556);
OSCFunc.trace(false);

)

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
		out: { | val | (val * 100).asInteger },
		pos: { | val | val * 2 - 1 },
		level: { | val | val * 3 },
		orientation: { | val | val * 5 + 2.5 }
	)
)
)









