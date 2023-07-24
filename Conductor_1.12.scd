// \M/ CONDUCTOR 1.12
// Execute the zones with the order below
// Sorun melody 1 loopu gırdıgınde clıppıng oluyor ses cok artıryor.

( // G Function is used for calculating western harmony intervals on a non fixed frequency and storing them as scales and chords
~det = [0, 1, 1.059, 1.122, 1.189, 1.259, 1.334, 1.414, 1.498, 1.587, 1.681, 1.782, 1.887, 2, 2.118, 2.244, 2.378, 2.518, 2.668, 2.828, 2.996, 3.174, 3.362, 3.564, 3.774];
g = {
	  arg a;
         ~chro   = ~det.value.collect{|allnotes| allnotes * a };
	     ~maj    = ~det[[0,1,3,5,6,8,10,12]].collect{|allnotes| allnotes * a };
	     ~minNat = ~det[[0,1,3,4,6,8,9,11]].collect{|allnotes| allnotes * a };
	     ~minHar = ~det[[0,1,3,4,6,8,9,12]].collect{|allnotes| allnotes * a };
	     ~minMel = ~det[[0,1,3,4,6,8,10,12]].collect{|allnotes| allnotes * a };
	     ~dorian =  ~det[[0,3,5,6,8,10,12,13]].collect{|allnotes| allnotes * a };
	    ~phrygian =  ~det[[0,5,6,8,10,12,13,15]].collect{|allnotes| allnotes * a };
	    ~mixolydian = ~det[[0,6,8,10,12,13,15,17]].collect{|allnotes| allnotes * a };
	    ~lydian =  ~det[[0,8,10,12,13,15,17,18]].collect{|allnotes| allnotes * a };
	    ~locrian =  ~det[[0,10,12,13,15,17,18,20]].collect{|allnotes| allnotes * a };
	    ~aeolian =  ~det[[0,12,13,15,17,18,20,22]].collect{|allnotes| allnotes * a };
    };
d = Dictionary.new;
    ~chordProg = { arg x;
	           var input, output;
	           input = x[[1,2,3,4,5,6,7]];
	~respsolo = input;
	           output =  [input ++ (input * 2) ++ (input * 4) ++ (input * 8) ++ (input * 16) ++ (input * 32) ++ (input * 64) ++ (input * 128) ++ (input * 256)].collect{|allnotes| allnotes};
	~notes = output[0];
	       d = (tonic3:  ~notes[[0,2,4,0,2]], \superTonic3: ~notes[[1,3,5,1,3]], mediant3: ~notes[[2,4,6,2,4]], subDominant3: ~notes[[3,5,7,3,5]], dominant3: ~notes[[4,6,8,4,6]], subMediant3: ~notes[[5,7,9,5,7]], leadingTone3: ~notes[[6,8,10,6,8]], tonic4:  ~notes[[0,2,4,6,0]], \superTonic4: ~notes[[1,3,5,7,1]], mediant4: ~notes[[2,4,6,8,2]], subDominant4: ~notes[[3,5,7,9,3]], dominant4: ~notes[[4,6,8,10,4]], subMediant4: ~notes[[5,7,9,11,5]], leadingTone4: ~notes[[6,8,10,12,6]], tonic5:  ~notes[[0,2,4,6,8]], \superTonic5: ~notes[[1,3,5,7,9]], mediant5: ~notes[[2,4,6,8,10]], subDominant5: ~notes[[3,5,7,9,11]], dominant5: ~notes[[4,6,8,10,12]], subMediant5: ~notes[[5,7,9,11,13]], leadingTone5: ~notes[[6,8,10,12,14]]);
	~respsolo = ~respsolo * 8;
	input.postln;
})
  //F function is used for determining a temporary chord selected from D Dictionary
(f = {
	arg samp;
	~samplechord = samp;
	~samplechord.postln;
	d.findKeyForValue(~samplechord).postln;
};
k = {
	arg length;
	~chordLength = length;
	~chordLength.postln;
};
h = {
	arg melody1;
	~melody1 = melody1;
	~melody1.postln;
};
)

(
Tdef(\chord, Prand([16,32,4,8,3,5,7,2,4,4,4,2,2], inf));
Tdef(\tone1, Prand([8,2,1.5,1.75,2,1,1,1,1,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.25,0.25,0.25,0.25,0.75,0.75,1.25,1.25,1,3,2], inf));
Tdef(\tone2, Prand([2,4,8], inf));
Tdef(\tone3, Prand([8,4,3,2,1,0.75,0.5,0.5,0.5,0.5,0.5,0.5,1,1,1,1,0.5,1,1,1], inf));
Tdef(\tone4, Prand([4,1,0.75,0.5,0.5,0.5,0.5,0.5,0.5,0.5,1,0.25,0.25,0.25], inf));
~index1 = 0;
)

(  // This is the header control unit, it is used for G functions foundation frequency
g.set(18);
~chordProg.set(~mixolydian);
)

(  //This Zone consists of 3 Synths and 1 effect / Group routing
SynthDef(\Leadsoloist,                 //  This synth is played for monophonic applications
	{| out = 0, freq = 0, amp = 0.1, gate = 1|
		var signal, env;
		signal = Saw.ar(freq, amp);
		env = EnvGen.kr(Env.sine(2, amp), gate, doneAction:Done.freeSelf);
		signal = signal * env;
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
SynthDef(\ReverbMachine,                 // This is a giant reverb machine
	{| out = 0, size = 1, moddepth = 0.1, earlydif = 1, time = 1, damp = 0|
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
~reverbGroup = Group.new(s, addAction:'addToTail');
~dronereverb = Synth(\ReverbMachine, [\size, 1,\moddepth, 0.1], ~reverbGroup);  // Reverbs Node
)

(  // Chord Generator Sequencer
(fork{loop{Tdef(\chord).asStream.value.wait;
	f.set(d.choose);
	k.set(Tdef(\tone2).asStream.value);
	~note1 = Synth(\ChordGenerator, [\freq, ((~samplechord[0]) * ([2,4,8,16,32].choose).postln).postln, \amp, [0.2,0.15,0.1,0.05,0.25].choose, \chordlength, ~chordLength], ~chordProgGroup);
	~note2 = Synth(\ChordGenerator, [\freq, ((~samplechord[1]) * ([2,4,8,16,32,64].choose).postln).postln, \amp, [0.2,0.15,0.1,0.05,0.25].choose, \chordlength, ~chordLength], ~chordProgGroup);
	~note3 = Synth(\ChordGenerator, [\freq, ((~samplechord[2]) * ([4,8,16,32,64].choose).postln).postln, \amp, [0.2,0.15,0.1,0.05,0.25].choose, \chordlength, ~chordLength], ~chordProgGroup);
	~note4 = Synth(\ChordGenerator, [\freq, ((~samplechord[3]) * ([4,8,16,32,64].choose).postln).postln, \amp, [0.2,0.15,0.1,0.05,0.25].choose, \chordlength, ~chordLength], ~chordProgGroup);
	~note5 = Synth(\ChordGenerator, [\freq, ((~samplechord[4]) * ([4,8,16,32,64,128].choose).postln).postln, \amp, [0.2,0.15,0.1,0.05,0.25].choose, \chordlength, ~chordLength], ~chordProgGroup);
	}});

// 3 Voice orchestral section sequencer
(fork{loop{Tdef(\tone1).asStream.value.wait;~tone = Synth(\Leadsoloist, [\freq, (~respsolo.choose)  * [1,2].choose,\amp, [0.2,0.15,0.1,0.05].choose], ~impLeadGroup)}});

(fork{loop{Tdef(\tone2).asStream.value.wait;~tone2 = Synth(\Leadsoloist, [\freq, (~samplechord[0]) * [4,8].choose,\amp, [0.2,0.15,0.1,0.05].choose], ~impLeadGroup)}});

(fork{loop{Tdef(\tone3).asStream.value.wait;~tone3 = Synth(\Leadsoloist, [\freq, (~samplechord.choose) * [4,8,16].choose, \amp, [0.2,0.15,0.1,0.05].choose], ~impLeadGroup)}});

(fork{loop{Tdef(\tone4).asStream.value.wait;~tone4 = Synth(\Leadsoloist, [\freq, (~samplechord.choose) * [8,16,32].choose, \amp, [0.2,0.15,0.1,0.05].choose], ~impLeadGroup)}});

(fork{loop{10.wait;
	h.set(Array.fill(9, {
    [0.2, 0.1, 0.1, 0.1, 0.1, 0.2, 0.05, 0.1].windex;   //!!!!!!!!!!!!!!!!
}));
}});
)

(
(fork{loop{1.wait;  // NEWWWW!!!!  Generative Pattern Sequencer  //
	~tone5 = Synth(\Leadsoloist, [\freq, (~respsolo[~melody1[~index1]]), \amp, [0.15,0.1,0.05].choose], ~melLeadGroup);
    ~index1 = ~index1 + 1;
	~index1.postln;
	~melody1[~index1].postln;
	if( ~index1 == 7, { ~index1= 0}, {~index1 = ~index1});
}});
)


( // Grain Sequencer
fork{
	loop{
		0.001.wait;
		Synth(\grains, [
			\grainLength, rrand(0.01, 0.5), \freq, ~notes.choose,
			\amp, 0.3
		], ~grainGroup)
	}
}
)
(0..7)
(   // Reverb Control Unit
~dronereverb.set(\size, 50, \moddepth, 100, \earlydif, 100, \time, 10, \damp, 0.1 );
)




