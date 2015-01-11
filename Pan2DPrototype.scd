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

//: Allocate internal bus for routing vertical pan to horizontal panners:
~ringBusses = Bus.audio(Server.default, 10);

//: test the above

~ringBusses;
~ringBusses.index;


//:

(
~vertical1 = { | out = 0 pos = 0 level = 1 width = 0 orientation = 0 rate = 1 |
	var source, pan;
	source = WhiteNoise.ar(0.1) * Decay2.kr(Impulse.kr(rate));
	pan = PanAz.ar(10, source, pos * 0.8, level, width * 8 + 2, orientation);
	Out.ar(out, pan);
}.play(args: [out: ~ringBusses.index]);
)

//:
~vertical1.set(\pos, 0.25);
//:
~vertical1.set(\pos, 0.5);
//:
~vertical1.set(\pos, 0.75);
//:
~vertical1.set(\pos, 1);

//:
~vertical1.set(\pos, 0);

//:

~vertical1.set(\width, 0);

//:

{ Out.ar(0, In.ar(51)) }.play(addAction: 'addToTail');

//:

(
~ring1 = { | in = 0 out = 0 pos = 0 level = 1 width = 2 orientation = 0 |
	var source, pan;
	source = In.ar(in);
	pan = PanAz.ar(14, source, pos, level, width, orientation);
	Out.ar(out, pan);
}.play(args: [in: ~ringBusses.index], addAction: 'addToTail');
)

~ring1.set(\pos, 1);

//:

(
~ring2 = { | in = 0 out = 0 pos = 0 level = 1 width = 2 orientation = 0 |
	var source, pan;
	source = In.ar(in);
	pan = PanAz.ar(14, source, pos, level, width, orientation);
	Out.ar(out, pan);
}.play(
	args: [in: ~ringBusses.index + 1, out: 14],
	addAction: 'addToTail'
);
)

//:

(
~ring3 = { | in = 0 out = 0 pos = 0 level = 1 width = 2 orientation = 0 |
	var source, pan;
	source = In.ar(in);
	pan = PanAz.ar(8, source, pos, level, width, orientation);
	Out.ar(out, pan);
}.play(
	args: [in: ~ringBusses.index + 2, out: 28],
	addAction: 'addToTail'
);
)

//:

(
~ring4 = { | in = 0 out = 0 pos = 0 level = 1 width = 2 orientation = 0 |
	var source, pan;
	source = In.ar(in);
	pan = PanAz.ar(6, source, pos, level, width, orientation);
	Out.ar(out, pan);
}.play(
	args: [in: ~ringBusses.index + 3, out: 36],
	addAction: 'addToTail'
);
)

//:

(
~ring5 = { | in = 0 out = 0 level = 1 |
	var source;
	source = In.ar(in);
	Out.ar(out, source);
}.play(
	args: [in: ~ringBusses.index + 4, out: 42],
	addAction: 'addToTail'
);
)

////////////////////////////////////////////////////////////////////

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
			~ring1.set(key, func.(msg[1]));
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









