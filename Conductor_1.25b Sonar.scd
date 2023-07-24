// \M/ CONDUCTOR 1.24 beta

//MKtl.openDescFolder
//MKtl.deviceTypes;
MKtl('myXL', "novation-launchcontrol-xl", multiIndex:0);
//MKtl('myXL').gui;
MKtl('myXL').trace;
//MKtl('myXL').elAt(\pg0, \sl,0).action = { "YO, sl!".postln };

(
for(1,7,{arg i;
k = MKtl('myXL').elAt(\pg0,\bt,\ctl,i,\on).action = {
 Synth(\LeadsoloistSawHuman, [\freq,

		~respsolo[i-1]], ~impLeadGroup)
}});
for(1,7,{arg i;
k = MKtl('myXL').elAt(\pg0,\bt,\fcs,i,\on).action = {
 Synth(\LeadsoloistSawHuman, [\freq,// delay.delayTime(dt);

		2 * ~respsolo[i-1]], ~impLeadGroup)
}});
)
//ZoomAudioD
Server.default.options.inDevice_("Universal Audio Thunderbolt");
Server.default.options.outDevice_("ZoomAudioD");

s.reboot
ServerOptions.devices
( // Scale Generator Beta
~gr = 1.6180339887;
~detgr16 = Array.new(24);
~detgr16.add(~gr);
for (0,15, { arg i; ~detgr16.add(~detgr16[i] * ~gr)});
~detgr16.normalize(1, 2);
)
243 /128
( // G Function is used for calculating western harmony intervals on a non fixed frequency and storing them as scales and chords
~det = [0, 1, 1.059, 1.122, 1.189, 1.259, 1.334, 1.414, 1.498, 1.587, 1.681, 1.782, 1.887, 2]; // ET-12
~dji = [0, 1, 1.041, 1.125, 1.200, 1.250, 1.333, 1.406, 1.500, 1.600, 1.666, 1.800, 1.875, 2]; // JI-12
~dpg = [0, 1, 1.053, 1.125, 1.185, 1.265, 1.333, 1.423, 1.500, 1.580, 1.687, 1.777, 1.898, 2]; // Phygtagorian-12
g = {           //           //                  //             //       //  1.800
//16:15(1.066) mı yoksa 10:9(1.111) mu mınor second, au4(1.4) mu dım5(1.422) mı 45:32 , 64:45?
	  arg a,b ;
         ~chro   = b.value.collect{|allnotes| allnotes * a };
	     ~maj    = b[[0,1,3,5,6,8,10,12]].collect{|allnotes| allnotes * a };
	     ~minNat = b[[0,1,3,4,6,8,9,11]].collect{|allnotes| allnotes * a };
	     ~minHar = b[[0,1,3,4,6,8,9,12]].collect{|allnotes| allnotes * a };
	     ~minMel = b[[0,1,3,4,6,8,10,12]].collect{|allnotes| allnotes * a };
	     ~dorian =  b[[0,1,3,4,6,8,10,11]].collect{|allnotes| allnotes * a };
	    ~phrygian =  b[[0,1,2,4,6,8,9,11]].collect{|allnotes| allnotes * a };
	    ~mixolydian = b[[0,1,3,5,6,8,10,11]].collect{|allnotes| allnotes * a };
	    ~lydian =  b[[0,1,3,5,7,8,10,12]].collect{|allnotes| allnotes * a };
	    ~locrian =  b[[0,1,2,4,6,7,9,11]].collect{|allnotes| allnotes * a };
	    ~gr16 = ~detgr16.collect{|allnotes| allnotes * a };
	    ~gr16 = ~gr16.normalize(~gr16[0], (~gr16[0] * 2));
	    ~gr16.addFirst(0);
    };
~chords = Dictionary.new;
    ~chordProg = { arg x;
	           var input, output;
	input = x[(1..((x.size) - 1))];
	~respsolo = input;
	           output =  [input ++ (input * 2) ++ (input * 4) ++ (input * 8) ++ (input * 16) ++ (input * 32) ++ (input * 64) ++ (input * 128) ++ (input * 256)].collect{|allnotes| allnotes};
	~notes = output[0];
	       ~chords = (tonic3:  ~notes[[0,2,4,0,2]], \superTonic3: ~notes[[1,3,5,1,3]], mediant3: ~notes[[2,4,6,2,4]], subDominant3: ~notes[[3,5,7,3,5]], dominant3: ~notes[[4,6,8,4,6]], subMediant3: ~notes[[5,7,9,5,7]], leadingTone3: ~notes[[6,8,10,6,8]], tonic4:  ~notes[[0,2,4,6,0]], \superTonic4: ~notes[[1,3,5,7,1]], mediant4: ~notes[[2,4,6,8,2]], subDominant4: ~notes[[3,5,7,9,3]], dominant4: ~notes[[4,6,8,10,4]], subMediant4: ~notes[[5,7,9,11,5]], leadingTone4: ~notes[[6,8,10,12,6]], tonic5:  ~notes[[0,2,4,6,8]], \superTonic5: ~notes[[1,3,5,7,9]], mediant5: ~notes[[2,4,6,8,10]], subDominant5: ~notes[[3,5,7,9,11]], dominant5: ~notes[[4,6,8,10,12]], subMediant5: ~notes[[5,7,9,11,13]], leadingTone5: ~notes[[6,8,10,12,14]]);
	~respsolo = ~respsolo * 8;
	input.postln;
	x.size.postln;
	~index1 = 0;
})

(
r = { arg a = 10; //Some kind of note value bank in accordance with the tempo
~bpm = a;
~notelength = Dictionary.new;
~notelength = (n1:~bpm/15, n2d:~bpm/20 ,n2:~bpm/30, n4d:~bpm/40, n4:~bpm/60, n8d:~bpm/80, n8: ~bpm/120, n16d:~bpm/160, n16:   ~bpm/240, n32d:~bpm/320, n32: ~bpm/480, n64d:~bpm/640, n64: ~bpm/960); // notelengths
~chordnotelength = ~notelength.atAll([\n1, \n2d, \n2 , \n4d, \n4, \n8d]);
};//chordnotelengths and Chord play times at the same time
)
~notelength[\n]

(f = {//Sample Chord Selector
	arg samp;
	~samplechord = samp;
	~samplechord.postln;
	~chords.findKeyForValue(~samplechord).postln;
};
h = { // Melody1 8 step phrase determinator
	arg melody1;
	~melody1 = melody1;
	~melody1.postln;
};
j = { // Harmonic Rate determinator
	arg hr1 = 1;
	~harmonicrate = hr1;
	~harmonicrate.postln;
};
k = { // Chord Length determinator
	arg length;
	~chordLength = length;
	~chordLength.postln;
};
b = { // Player time determinator
	arg pr1 = 1;
	~playrate = pr1;
	~playrate.postln;
};
d = { // Chord player time determinator
	arg cpr1 = 1;
	~chordplayrate = cpr1;
	~chordplayrate.postln;
};
)


(  //This Zone consists of 3 Synths and 1 effect / Group routing
~me = SynthDef(\LeadsoloistSawHuman,                 //  This synth is played for monophonic applications
	{| out = 0, freq = 0, amp = 0.4, gate = 1, length = 1|
		var signal, env;
		signal = Saw.ar(freq, amp/2);
		env = EnvGen.kr(Env.sine(length, amp), gate, doneAction:Done.freeSelf);
		signal = signal * env;
		signal = signal !2;
		Out.ar(out, signal);
	}
).add;
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
SynthDef(\ReverbMachine,                 // This is a giant reverb machine
	{| out = 0, size = 1, moddepth = 0.1, earlydif = 0, time = 0, damp = 0|
		var signal;
		signal = In.ar(out, 1);
		signal = JPverb.ar(signal,t60: time, size: size, modDepth: moddepth, earlyDiff: earlydif, damp: damp);
		signal = signal !2;
		Out.ar(out, signal);
	};
).add;
~chordProgGroup = Group.new(s, addAction:'addToHead');  //Groups are in order of execution
~impLeadGroup = Group.new(s, addAction:'addToTail');
~melLeadGroup = Group.new(s, addAction:'addToTail');
~grainGroup = Group.new(s, addAction:'addToTail');
~rhythmGroup = Group.new(s, addAction:'addToTail');
~reverbGroup = Group.new(s, addAction:'addToTail');
~dronereverb = Synth(\ReverbMachine, [\size, 1,\moddepth, 0.1], ~reverbGroup);
~rhythmGroup = Group.new(s, addAction:'addToTail');
~reverbRhythmGroup = Group.new(s, addAction:'addToTail');
~rhythmreverb = Synth(\ReverbMachine, [\size, 1,\moddepth, 0.1], ~reverbRhythmGroup);
SynthDef(\RezDrums,{
    |out = 0, time1 = 7, freQSaw = 100, freQSin = 1000 freQRez = 500, amp = 0, gate = 1, attack = 0.01, release = 0.3|
	var signal, env;
	signal = GVerb.ar(
		(Resonz.ar(
			(Impulse.ar(time1)) * (Saw.ar(
				freQSaw, 12)), freQRez, 1.5, mul:0.5))) * SinOsc.ar(
		freQSin, mul:12)   * amp;
	env = EnvGen.kr(Env.perc(attack,release), gate, doneAction:Done.freeSelf);
	signal = signal * env;
Out.ar(out,signal);
	    }
).add;
SynthDef(\fm_grain_test, {arg gate = 1, amp = 0.01, freq = 0, freq2 = 0;
    Out.ar(0,
        FMGrain.ar(Impulse.ar(20), 0.2, freq, freq2,
            LFNoise1.kr(1).range(1, 10),
            EnvGen.kr(
                Env([0, 1, 0], [1, 1], \sin, 1),
                gate,
                levelScale: amp,
                doneAction: Done.freeSelf)
        )
    )
}).add;
)







(// Harmonic Rate belirleme loopu
~harmonicrate = 10;
~playrate = 3;
(
(fork{loop{15.wait;j.set((2..15).choose); }});
(fork{loop{~harmonicrate.wait;f.set(~chords.choose)}});
(fork{loop{15.wait;k.set(~chordnotelength.choose);}}); //Chordlength belırleme loopu

(fork{loop{3.wait;b.set((0.5..5.5).choose);}});  //Player time determination loop
(fork{loop{~playrate.wait;
~p1 = ~notelength.choose.postln;
~p2 = ~notelength.choose.postln;
~p3 = ~notelength.choose.postln;
~p4 = ~notelength.choose.postln;
~p5 = ~notelength.choose.postln;
~p6 = ~notelength.choose.postln;
~p7 = ~notelength.choose.postln;
~p8 = ~notelength.choose.postln;
	~d1 = ~notelength.choose.postln;
	~d2 = ~notelength.choose.postln;

}});

fork{loop{10.wait;d.set((3.5..10.5).choose);}}; //Chord player time determination loop
fork{loop{~chordplayrate.wait;~c1 = ~chordnotelength.choose.postln;}};
))


(
g.set( 24 , ~det);
~chordProg.set(~minHar);   //
r.set(125);
)
(

)
(
~chordvoice.stop
~voicesaw6.stop
~voicesine.stop
~voicechimes.stop
~voicegranular.stop
)
(   // Reverb Control Unit
~dronereverb.set(\size, 100, \moddepth, 100, \earlydif, 100, \time ,1, \damp, 0.1 );
~rhythmreverb.set(\size,1, \moddepth, 1, \earlydif, 1, \time,20, \damp, 1,\low, 0.3 );
)
~kick.stop;
~kDrum.stop;
~fDrum.stop;
~kick = (fork{loop{ ~notelength[\n32d].wait;~tone = Synth(\RezDrums, [\amp, [0.3,0.25,0.15].choose,
	\freQSaw, 20,
	\freQSin, 20,
	\freQRez, 60,
	\amp, 6,
    \release, 0.01,
	\attack, 0.01
], ~rhythmGroup)}});

~fDrum = (fork{loop{ ~d1.wait;~tone = Synth(\RezDrums, [\amp, [0.3,0.25,0.15].choose,
	\freQSaw, 200,
	\freQSin, 200,
	\freQRez, 300,
	\amp, 2,
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
~voiceFM.stop
~voiceFM = fork{loop{~p1.wait;~tone6 = Synth(\fm_grain_test, [\freq, (~samplechord.choose) * [8,16,32].choose, \freq2, (~samplechord.choose) * [8,16,32].choose,  \amp, [0.002,0.004,0.003].choose], ~impLeadGroup);}};

~voicesaw5 = (fork{loop{~p1.wait;~tone = Synth(\LeadsoloistSaw, [\freq, (~respsolo.choose)  * [1,2].choose,\amp, [0.3,0.25,0.15].choose], ~impLeadGroup)}});

~voicesine5 = fork{loop{~p4.wait;~tone4 = Synth(\LeadsoloistSine, [\freq, (~samplechord.choose) * [8,16,32].choose, \amp, [0.4,0.30,0.2,0.1].choose], ~impLeadGroup)}};

~voicechimes3 = fork{loop{~p6.wait;~tone6 = Synth(\Chimes, [\freq, (~samplechord.choose) * [8,16,32,64,128].choose, \freq2, (~samplechord.choose) * [8,16,32,64].choose, \res, (~samplechord.choose) * [8,16,32,64,128].choose, \amp, [0.3,0.4,0.5].choose], ~impLeadGroup)}};

(
~chordvoice = (fork{loop{~c1.wait;  // Chord Generator Sequencer
	~note1 = Synth(\ChordGenerator, [\freq, ((~samplechord[0]) * ([2,4,8,16,32].choose).postln).postln, \amp, [0.15,0.1,0.05].choose, \chordlength, ~chordLength], ~chordProgGroup);
	~note2 = Synth(\ChordGenerator, [\freq, ((~samplechord[1]) * ([2,4,8,16,32,64].choose).postln).postln, \amp, [0.15,0.1,0.05].choose, \chordlength, ~chordLength], ~chordProgGroup);
	~note3 = Synth(\ChordGenerator, [\freq, ((~samplechord[2]) * ([4,8,16,32,64].choose).postln).postln, \amp, [0.15,0.1,0.05].choose, \chordlength, ~chordLength], ~chordProgGroup);
	~note4 = Synth(\ChordGenerator, [\freq, ((~samplechord[3]) * ([4,8,16,32,64].choose).postln).postln, \amp, [0.15,0.1,0.05].choose, \chordlength, ~chordLength], ~chordProgGroup);
	~note5 = Synth(\ChordGenerator, [\freq, ((~samplechord[4]) * ([4,8,16,32,64].choose).postln).postln, \amp, [0.15,0.1,0.05].choose, \chordlength, ~chordLength], ~chordProgGroup);
}});

// 4 Voice orchestral section sequencer
~voicesaw1 = (fork{loop{~p1.wait;~tone = Synth(\LeadsoloistSaw, [\freq, (~respsolo.choose)  * [2].choose,\amp, [0.05].choose], ~impLeadGroup)}});

~voicesaw2 = fork{loop{~p2.wait;~tone2 = Synth(\LeadsoloistSaw, [\freq, (~samplechord.choose) * [4,8].choose,\amp, [0.2,0.15,0.1,0.05].choose], ~impLeadGroup)}};

~voicesaw3 = fork{loop{~p3.wait;~tone3 = Synth(\LeadsoloistSaw, [\freq, (~samplechord[0]) *4, \amp, [0.2,0.15,0.1,0.05].choose], ~impLeadGroup)}};

~voicesaw4 = fork{loop{~p4.wait;~tone4 = Synth(\LeadsoloistSaw, [\freq, (~samplechord.choose) * [8,16,32].choose, \amp, [0.2,0.15,0.1,0.05].choose], ~impLeadGroup)}};

~voicesine1 = fork{loop{~p1.wait;~tone = Synth(\LeadsoloistSine, [\freq, (~respsolo.choose)  * [2].choose,\amp, [0.4,0.30,0.2,0.1].choose], ~impLeadGroup)}};

~voicesine2 = fork{loop{~p2.wait;~tone2 = Synth(\LeadsoloistSine, [\freq, (~samplechord.choose) * [4,8].choose,\amp, [0.4,0.30,0.2,0.1].choose], ~impLeadGroup)}};

~voicesine3 = fork{loop{~p3.wait;~tone3 = Synth(\LeadsoloistSine, [\freq, (~samplechord[0]) * 4, \amp, [0.4,0.30,0.2,0.1].choose], ~impLeadGroup)}};

~voicesine4 = fork{loop{~p4.wait;~tone4 = Synth(\LeadsoloistSine, [\freq, (~samplechord.choose) * [8,16,32].choose, \amp, [0.4,0.30,0.2,0.1].choose], ~impLeadGroup)}};

~voicechimes1 = fork{loop{~p6.wait;~tone6 = Synth(\Chimes, [\freq, (~samplechord.choose) * [8,16,32,64,128].choose, \freq2, (~samplechord.choose) * [8,16,32,64].choose, \res, (~samplechord.choose) * [8,16,32,64,128].choose, \amp, [0.3,0.4,0.5].choose], ~impLeadGroup)}};

~voicechimes2 = fork{loop{~p6.wait;~tone6 = Synth(\Chimes2, [\freq, (~samplechord.choose) * [8,16,32,64,128].choose, \freq2, (~samplechord.choose) * [8,16,32,64].choose, \res, (~samplechord.choose) * [8,16,32,64,128].choose, \amp, [0.3,0.4,0.5].choose], ~impLeadGroup)}};

a = (Pbind(\instrument, \RezDrums,
	\freQSaw, 20,
	\freQSin, 20,
	\freQRez, 30,
	\amp, 1.7,
	//\dur, Prand([0.5,0.25,0.5,0.25,0.25,0.5,0.25], inf),
	\dur, ~notelength[\n32d],
	\release, 0.09,
	 \attack, 0.1,
	\time1, 1
).play;
);
e = (Pbind(\instrument, \RezDrums,
	\freQSaw, Prand([25, 25 * 1.498], inf),
	\freQSin, Prand([25, 50 * 1.498], inf),
	\freQRez, Prand([100, 50 * 1.498, 100 * 1.189], inf),
	\amp, 0.5,
	\dur, Prand([~notelength[\n32],~notelength[\n32d],~notelength[\n16]], inf),
	\release, 0.1,
	\time1, 07
).play;
);
y = (Pbind(\instrument, \RezDrums,
	\freQSaw, 250,
	\freQSin, 1000,
	\freQRez, 1000,
	\amp, 0.05,
	\dur, Prand([~notelength[\n8],~notelength[\n16d],~notelength[\n16]], inf),
	\release, 0.1,
	\time1, 7
).play;
);
a.mute;
e.mute;
y.mute;
)
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