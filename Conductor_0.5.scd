
ServerOptions.new.memSize = 65536;

(
SynthDef(\Leadsoloist,                 // This is Main Synth
	{| out = 0, freq = 0, amp = 0.1, gate = 1|
		var signal;
		signal = GVerb.ar(Saw.ar(freq, amp));
		Out.ar(out,signal);
	}
).add;
SynthDef(\ChordGenerator,                 // This is Main Synth
	{| out = 0, freq = 0, amp = 0.1, chordlength = 2, gate = 1|
		var signal, env;
		signal = GVerb.ar(Saw.ar(freq, amp));
		env = EnvGen.kr(Env.sine(chordlength, amp), gate, doneAction:Done.freeSelf);
		signal = signal * env;
		Out.ar(out,signal);
	}
).add;
~chordProgGroup = Group.new(s, addAction:'addToHead');
~impLeadGroup = Group.new(s, addAction:'addToHead');
)

(
~tone = Synth(\Leadsoloist, [\freq, ~samplechord[0] * 4,\amp, 0.07], ~impLeadGroup);
~tone2 = Synth(\Leadsoloist, [\freq, ~samplechord[1] * 8,\amp, 0.08], ~impLeadGroup);
~tone3 = Synth(\Leadsoloist, [\freq, ~samplechord[2] * 16,\amp, 0.07], ~impLeadGroup);
)

(
(fork{loop{0.50.wait;~tone.set(\freq, (~respsolo.choose)  * 4);}});
(fork{loop{8.wait;~tone2.set(\freq, (~respsolo.choose) * 4 );}});
(fork{loop{0.125.wait;~tone3.set(\freq, (~respsolo.choose) * [16, 32].choose);}});
)

(
(fork{loop{2.wait;
	fork{loop{([0.125, 0.25, 0.50, 0.75, 1, 2].choose).wait;~tone.set(\freq, (~respsolo.choose)  * [4,8,16,32,64].choose);
}}}});
(fork{loop{8.wait;~tone2.set(\freq, (~respsolo.choose) * 4 );}});
)

(
(fork{loop{6.wait;
	f.set(n.choose);
	~note1 = Synth(\ChordGenerator, [\freq, ((~samplechord[0]) * ([2,4,8,16,32].choose).postln).postln, \amp, 0.2], ~chordProgGroup);
	~note2 = Synth(\ChordGenerator, [\freq, ((~samplechord[1]) * ([2,4,8,16,32,64].choose).postln).postln, \amp, 0.2], ~chordProgGroup);
	~note3 = Synth(\ChordGenerator, [\freq, ((~samplechord[2]) * ([4,8,16,32,64].choose).postln).postln, \amp, 0.2], ~chordProgGroup);
	~note4 = Synth(\ChordGenerator, [\freq, ((~samplechord[3]) * ([4,8,16,32,64,128].choose).postln).postln, \amp, 0.2], ~chordProgGroup);
	}});
)


(
~grainGroup = Group.new(s, addAction:'addToHead');
SynthDef(\grains, { | out = 0, gate = 1, grainLength = 0.1, amp = 1, freq = 0|
	var signal, env, pan;
	pan = LFNoise1.kr(1).range(-1, 1);
	env = EnvGen.kr(Env.perc(0.01, grainLength, amp), gate, doneAction:Done.freeSelf);
	signal = Saw.ar(freq, 0.3);
	signal = {signal}!2 * env;
	Out.ar(out, Pan2.ar(signal, pan, amp / 5));
}).add;
)


(
fork{
	loop{
		0.01.wait;
		Synth(\grains, [
			\grainLength, rrand(0.01, 0.5), \freq, ~notes.choose
		], ~grainGroup)
	}
}
)


(
~det = [0, 1, 1.059, 1.122, 1.189, 1.259, 1.334, 1.414, 1.498, 1.587, 1.681, 1.782, 1.887];
g = {
	  arg a;
         ~chro = ~det.value.collect{|allnotes| allnotes * a };
	     ~maj = ~det[[0,1,3,5,6,8,10,12]].collect{|allnotes| allnotes * a };
	     ~minNat = ~det[[0,1,3,4,6,8,9,11]].collect{|allnotes| allnotes * a };
	     ~minHar = ~det[[0,1,3,4,6,8,9,12]].collect{|allnotes| allnotes * a };
	     ~minMel = ~det[[0,1,3,4,6,8,10,12]].collect{|allnotes| allnotes * a };
    };
d = Dictionary.new;
k = Dictionary.new;
n = Dictionary.new;
~chordProg = { arg x;
	           var input, output;
	           input = x[[1,2,3,4,5,6,7]];
	           ~respsolo = input;
	           output =  [input ++ (input * 2) ++ (input * 4) ++ (input * 8) ++ (input * 16) ++ (input * 32) ++ (input * 64) ++                           (input * 128) ++ (input * 256)].collect{|allnotes| allnotes};
	           ~notes = output[0];
	d = (tonic3:  ~notes[[0,2,4]], \superTonic3: ~notes[[1,3,5]], mediant3: ~notes[[2,4,6]], subDominant3: ~notes[[3,5,7]], dominant3: ~notes[[4,6,8]], subMediant3: ~notes[[5,7,9]], leadingTone3: ~notes[[6,8,10]]);
	k = (tonic4:  ~notes[[0,2,4,6]], \superTonic4: ~notes[[1,3,5,7]], mediant4: ~notes[[2,4,6,8]], subDominant4: ~notes[[3,5,7,9]], dominant4: ~notes[[4,6,8,10]], subMediant4: ~notes[[5,7,9,11]], leadingTone4: ~notes[[6,8,10,12]]);
	n = (tonic5:  ~notes[[0,2,4,6,8]], \superTonic5: ~notes[[1,3,5,7,9]], mediant5: ~notes[[2,4,6,8,10]], subDominant5: ~notes[[3,5,7,9,11]], dominant5: ~notes[[4,6,8,10,12]], subMediant5: ~notes[[5,7,9,11,13]], leadingTone5: ~notes[[6,8,10,12,14]]);
	input.postln;
}
)

(
f = {
	arg samp;
	~samplechord = samp;
	~samplechord.postln;
}
)





(
g.set(16.00);
~chordProg.set(~minHar);
)
d[\tonic3];
~maj
~chro
~samplechord[0]
~samplechord
f.set(d.choose)
~samplechord
k[\tonic4];
n[\tonic5];



















