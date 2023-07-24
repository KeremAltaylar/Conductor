



(  //This Zone consists of 3 Synths and 1 effect / Group routing
SynthDef(\LeadsoloistSaw,                 //  This synth is played for monophonic applications
	{| out = 0, freq = 0, amp = 0.05, gate = 1, length = 1|
		var signal, env;
		signal = Saw.ar(freq, amp);
		env = EnvGen.kr(Env.sine(length, amp), gate, doneAction:Done.freeSelf);
		signal = signal * env;
		signal = signal !2;
		Out.ar(out, signal);
	}
).add;
SynthDef(\LeadsoloistSine,                 //  This synth is played for monophonic applications
	{| out = 0, freq = 0, amp = 0.1, gate = 1, length = 1|
		var signal, env;
		signal = SinOsc.ar(freq, amp);
		env = EnvGen.kr(Env.sine(length, amp), gate, doneAction:Done.freeSelf);
		signal = signal * env;
		signal = signal * 0.13;
		signal = signal !2;
		Out.ar(out, signal);
	}
).add;
SynthDef(\ChordGenerator,                 // This synth is player for polyphonic applications
	{| out = 0, freq = 0, amp = 0.1, chordlength = 2, gate = 1|
		var signal, env;
		signal = Saw.ar(freq, amp);
		env = EnvGen.kr(Env.sine(chordlength, amp), gate, doneAction:Done.freeSelf);
		signal = signal * env;
		signal = signal !2;
		Out.ar(out, signal);
	}
).add;
SynthDef(\grains,   //This synth is used for granular scale application
	{ | out = 0, gate = 1, grainLength = 0.1, amp = 0.6, freq = 0|
	var signal, env, pan;
	pan = LFNoise1.kr(1).range(-1, 1);
	env = EnvGen.kr(Env.perc(0.01, grainLength, amp), gate, doneAction:Done.freeSelf);
	signal = Saw.ar(freq, 0.3);
	signal = {signal}!2 * env;
	Out.ar(out, Pan2.ar(signal, pan, amp / 5));
}).add;
SynthDef(\Chimes2,                 //  This synth is played for Chimes
	{| out = 0, freq = 0, amp = 0.1, gate = 1, attack = 0.05, release = 0.5, harm = 400, freq2 = 200, res = 110|
		var signal,signal2, env;
		signal = Streson.ar(Spring.ar(Saw.ar(freq,amp),3),10, 0.9);
		signal2 = Resonz.ar(SinOsc.ar(freq2, 0 ,amp),res);
		env = EnvGen.kr(Env.perc(attack,release), gate, doneAction:Done.freeSelf);
		signal = signal2;
		signal = signal * env;
		signal = signal * 0.1;
		signal = signal !2;
		Out.ar(out, signal);
}).add;
SynthDef(\Chimes,                 //  This synth is played for Chimes
	{| out = 0, freq = 0, amp = 0.1, gate = 1, attack = 0.05, release = 0.5, harm = 400, freq2 = 200, res = 110|
		var signal,signal2, env;
		signal = Streson.ar(Spring.ar(Saw.ar(freq,amp),3),10, 0.9);
		signal2 = Resonz.ar(SinOsc.ar(freq2, 0 ,amp),res);
		env = EnvGen.kr(Env.perc(attack,release), gate, doneAction:Done.freeSelf);
		signal = signal ; //* signal2;
		signal = signal * env;
		signal = signal * 0.1;
		signal = signal !2;
		Out.ar(out, signal);
}).add;
)
(
SynthDef(\ReverbMachine,
	{| out = 0, size = 1, moddepth = 0.1, earlydif = 0, time = 0, damp = 0, low = 1, mid = 1, high = 1|
		var signal;
		signal = In.ar(out, 1);
		signal = JPverb.ar(signal,t60: time, size: size, modDepth: moddepth, earlyDiff: earlydif, damp: damp, low: low, mid:mid, high:high,);
		signal = signal !2;
		Out.ar(out, signal);
	};
).add;
SynthDef(\Distortion,
	{| out = 0, amp = 0.008, smooth = 0.03|
		var signal;
		signal = In.ar(out, 1);
		signal = CrossoverDistortion.ar(signal,amp: amp, smooth: smooth);
		signal = signal !2;
		Out.ar(out, signal);
	};
).add;
SynthDef(\Delay,                 // This is a giant reverb machine
	{| out = 0, fb = 0.9, time = 2.0, size = 1.0|
		var signal;
		signal = In.ar(out, 1);
		signal = Greyhole.ar(signal,delayTime: time, size: size, feedback: fb);
		signal = signal !2;
		Out.ar(out, signal);
	};
).add;

~dronereverb = Synth(\ReverbMachine, [\size, 1,\moddepth, 0.1]);
~distortion = Synth(\Distortion, [\amp, 0.01,\smooth, 0.05], s);
~delay = Synth(\Delay, [\amp, 0.1,\smooth, 0.5], s);

~rhythmreverb = Synth(\ReverbMachine, [\size, 1,\moddepth, 0.1]);
SynthDef(\RezDrums,{
    |out = 0, time1 = 7, freQSaw = 100, freQSin = 1000 freQRez = 500, amp = 0, attack = 0.01, release = 0.3|
	var signal, env;
	signal = GVerb.ar(
		(Resonz.ar(
			(Impulse.ar(time1)) * (Saw.ar(
				freQSaw, 12)), freQRez, 1.5, mul:0.5))) * SinOsc.ar(
		freQSin, mul:12)   * amp;
	env = EnvGen.kr(Env.perc(attack,release), doneAction:Done.freeSelf);
	signal = signal * env;
Out.ar(out,signal);	    }
).add;
)
ServerOptions.new
ServerOptions.devices
s.options.memSize
s.reboot
	var mes = "kerem";
	mes.postln

(   // Reverb Control Unit
~dronereverb.set(\size, 1000, \moddepth, 1000, \earlydif, 1000, \time ,1;, \damp, 0, \low, 0, \mid ,1, \high,1 );
~rhythmreverb.set(\size,1, \moddepth, 1, \earlydif, 1, \time,0, \damp, 1,\low, 0 );
~distortion.set(\amp, 0.008, \smooth, 0.03);  // 0.008 & 0.03
~delay.set(\time,1.3 , \fb, 0.75, \size,0);  // 0.008 & 0.03
)
y.stop;
~e.stop
a = (Pbind(\instrument, \RezDrums,
	\freQSaw, 20,
	\freQSin, 20,
	\freQRez, 30,
	\amp, 1.7,
	//\dur, Prand([0.5,0.25,0.5,0.25,0.25,0.5,0.25], inf),
	\dur,1,
	\release, 0.09,
	 \attack, 0.1,
	\time1, 1
).play;
);
e = (Pbind(\instrument, \RezDrums,
	\freQSaw, 300,
	\freQSin, 200,
	\freQRez, 100,
	\amp, 0.5,
	\dur, 0.25,
	\release, 0.1,
	\time1, 0.7
).play;
);
y = (Pbind(\instrument, \RezDrums,
	\freQSaw, 250,
	\freQSin, 1000,
	\freQRez, 1000,
	\amp, 0.05,
	\dur, 0.5,
	\release, 0.1,
	\time1, 7
).play;
);
y.stop

~kick.stop;
~kDrum.stop;
~fDrum.stop;
~kick = (fork{loop{ ~notelength[\n32d].wait;~tone = Synth(\RezDrums, [\amp, [0.3,0.25,0.15].choose,
	\freQSaw, 20,
	\freQSin, 20,
	\freQRez, 60,
	\amp, 12,
    \release, 0.01,
	\attack, 0.01
], ~rhythmGroup)}});

~fDrum = (fork{loop{ ~d1.wait;~tone = Synth(\RezDrums, [\amp, [0.3,0.25,0.15].choose,
	\freQSaw, 200,
	\freQSin, 200,
	\freQRez, 300,
	\amp, 3,
    \release, 0.01,
	\attack, 0.01
], ~rhythmGroup)}});
~kDrum = (fork{loop{ ~d2.wait;~tone = Synth(\RezDrums, [\amp, [0.3,0.25,0.15].choose,
	\freQSaw, 200 * 3,
	\freQSin, 200 * 3,
	\freQRez, 300 * 3,
	\amp, 0.65 ,
    \release, 0.01,
	\attack, 0.01
], ~rhythmGroup)}});


(
~voicegranular = ( // Grain Sequencer
 fork{
	loop{
		0.005.wait;
		Synth(\grains, [
			\grainLength, rrand(0.01, 0.5), \freq, ~notes.choose,
			\amp, 0.2
		], ~grainGroup)
	}
}
)
)
 ~voicegranular.stop





[s,Limiter.ar(s, 2 , 0.01)] //Limiter