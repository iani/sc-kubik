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
~test0 = { | out = 0 pos = 0 level = 1 width = 2 orientation = 0 rate = 1 |
	var source, pan;
	source = WhiteNoise.ar(0.1) * Decay2.kr(Impulse.kr(rate));
	pan = PanAz.ar(5, source, pos, level, width, orientation);
	Out.ar(out, pan);
}.play;
)