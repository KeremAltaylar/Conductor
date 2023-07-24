
//DroneMachine ~\M/

//Run the g funciton at the bottom of the code firstly, then execute all areas which are established with paranthesis downwards in order.

(
ServerOptions.new.memSize = 65536;
g;
g.set(123.123);   // Set the main frequency on top of which all the harmony will be set, to any number between the range of 0-150
)


(
SynthDef(\DroneMachine,                 // This is Main Synth
	{| out = 0, freq = 0, amp = 0.1|
		var signal = GVerb.ar(Saw.ar(freq, amp));
		Out.ar(out,signal);
	}
).add;
)

(
~impLeadGroup = Group.new(s, addAction:'addToHead');    //  First Group Impro solo
~tones = Synth(\DroneMachine, [\freq, ~haRmiNorScale0[1],\amp, 0.01], ~impLeadGroup);
~tones2 = Synth(\DroneMachine, [\freq, ~haRmiNorScale2[5],\amp, 0.01], ~impLeadGroup);
~tones3 = Synth(\DroneMachine, [\freq, ~haRmiNorScale2[3],\amp, 0.005], ~impLeadGroup);
)

(
(fork{loop{0.50.wait;~tones.set(\freq, ~haRmiNorScale2.choose);}});
(fork{loop{0.25.wait;~tones2.set(\freq, ~haRmiNorScale3.choose);}});   // Start the Engines of loops
(fork{loop{0.125.wait;~tones3.set(\freq, ~haRmiNorScale5.choose);}});  // These can be stared individually as well
)


(
~chordProgGroup = Group.new(s, addAction:'addToHead');// Second group random chord generator(can be set to doM5 or miN1
x = {
	4.do{Synth(\DroneMachine, [\freq, ~miN1ArpeggioAll[exprand(1, 18)], \amp, 0.5 / 60], ~chordProgGroup);
}}
)

(
x.value    // Call x
)
~chordProgGroup.set(\freq, ~miN1ArpeggioAll[exprand(1, 18)]); // After you executed all areas, come back to this and change the freq by executing this
~chordProgGroup.free




(
~grainGroup = Group.new(s, addAction:'addToTail');
SynthDef(\grains, { | out = 0, gate = 1, grainLength = 0.1, amp = 0.5, freq = 0|
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
			\grainLength, rrand(0.1, 0.7), \freq, ~haRmiNorScale2.choose
		], ~grainGroup)
	}
}
)



//Three groups have been established



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




//A project for Frequency-typing style Chord Drone Oscillator Machine 5  ~\M/~
// Tonal harmony intervals can be used to any non-fixed frequency   ~\M/~
// Second addition can be, when this programm is established can be a wavelength visaulization attachment   ~\M/~

(
g = { arg a;  // First argument which is typed as float here will be the tone of the harmonic sturcture regardless of its value as fitting into the pre-determined tuning systems.
    var uniSon, octaVeUp, octaVeDown, perFectFifthUp, diMinishedFifthUp, miNorSecondUp, maJorSecondUp, miNorSixthUp, maJorSixthUp, miNorThirdUp, maJorThirdUp, chorDal3rd, chorDal5th, miNorSeventhUp, maJorSeventhUp, miNorNinthUp, maJorNinthUp, perFectEleventhUp, auGmentedEleventhUp, siLence, perFectFourthUp;
	uniSon = a; // All proportions based on the 440 Hertz= A4 assumption and 3 sample notes with their relative intervals choosen to demnstrate the general proportion
	octaVeDown = a / 2; // Half of the frequency; get the same note which is an octave below
	octaVeUp = a * 2; // Twice the frequency; get the same note which is an octave below
	miNorThirdUp = a * 1.189; // Frequency times 1.189 equals minor third up
	maJorThirdUp = a * 1.259; // Frequency times 1.259 equals minor third up
	diMinishedFifthUp = a * 1.414; // Frequency times 1.414 equals diminished fifth up
	perFectFifthUp = a * 1.498; // Frequency times 1.498 equals perfect fifth up
	miNorSeventhUp = a * 1.782; // Frequency times 1.782 equals minor seventh up
	maJorSeventhUp = a * 1.887; // Frequency times 1.887 equals minor seventh up
	miNorNinthUp = a * 2.119; // Frequency times 2.119 equals minor ninth up  // octave + minor second
	maJorNinthUp = a * 2.245; // Frequency times 2.245 equals minor ninth up // octave + major second
	perFectEleventhUp = a * 2.670; // Frequency times 2.670 equals perfect eleventh up  // octave + perfecth fourth
	auGmentedEleventhUp = a * 2.829; // Frequency times 2.829 equals augmented eleventh up // octave + augmented fourth
	siLence = a * 0; // To make the Osc silent frequency times 0
	miNorSecondUp = a * 1.059; // For those 5; they will not be used in chord built but will be used in scale building
	maJorSecondUp = a * 1.122; // Same principle of calculating the intervals
	miNorSixthUp = a * 1.587;
	maJorSixthUp = a * 1.621;
	perFectFourthUp = a * 1.334;
	~noTe1 = [siLence, uniSon, miNorSecondUp, maJorSecondUp, miNorThirdUp, maJorThirdUp, perFectFourthUp, diMinishedFifthUp, perFectFifthUp, miNorSixthUp, maJorSixthUp, miNorSeventhUp ,maJorSeventhUp, octaVeUp, miNorNinthUp, maJorNinthUp, perFectEleventhUp, auGmentedEleventhUp];
	// noTe1 is the main octave array
	("MainFrequency: " + uniSon + "            [1]").postln;
	("OctaveDown: " + octaVeDown + "             [2]" ).postln;
	("MiNorThirdUp: " + miNorThirdUp + "           [3]").postln;
	("MaJorThirdUp: " + maJorThirdUp + "           [4]").postln;
    ("DiminishedFifthUp: " + diMinishedFifthUp + "      [5]").postln;
	("PerfectFifthUp: " + perFectFifthUp + "         [6]").postln;
	("MiNorSeventhUp: " + miNorSeventhUp + "         [7]").postln;
	("MaJorSeventhUp: " + maJorSeventhUp + "         [8]").postln;
	("OctaveUp: " + octaVeUp + "                 [9]").postln;
	("MiNorNinthUp: " + miNorNinthUp + "           [10]").postln;
	("MaJorNinthUp: " + maJorNinthUp + "           [11]").postln;
	("perFectEleventhUp: " + perFectEleventhUp + "      [12]").postln;
	("auGmentedEleventhUp: " + auGmentedEleventhUp + "    [13]").postln;
	~noTe2 = ~noTe1.collect{|allnotes2| (allnotes2 * 2)}; // second octave array
	~noTe3 = ~noTe2.collect{|allnotes3| (allnotes3 * 2)}; // third octave array
	~noTe4 = ~noTe3.collect{|allnotes4| (allnotes4 * 2)}; // fourth octave array
	~noTe5 = ~noTe4.collect{|allnotes5| (allnotes5 * 2)}; // fifth octave array
	~haRmiNorScale00 = ~haRmiNorScale0.collect{|allnotes11| (allnotes11 / 2)}; //
	~haRmiNorScale0 = ~haRmiNorScale.collect{|allnotes10| (allnotes10 / 2)}; //
	~haRmiNorScale2 = ~haRmiNorScale.collect{|allnotes6| (allnotes6 * 2)}; //
	~haRmiNorScale3 = ~haRmiNorScale2.collect{|allnotes7| (allnotes7 * 2)}; //
	~haRmiNorScale4 = ~haRmiNorScale3.collect{|allnotes8| (allnotes8 * 2)}; //
	~haRmiNorScale5 = ~haRmiNorScale4.collect{|allnotes9| (allnotes9 * 2)}; //
	~miNArpeggio0 = ~miNArpeggio.collect{|allnotes7| (allnotes7 / 2)}; //
	~maJorScale = [uniSon, uniSon, maJorSecondUp, maJorThirdUp, perFectFourthUp, perFectFifthUp, maJorSixthUp, maJorSeventhUp ,octaVeUp]; // Major Scale Array
	~naTmiNorScale = [uniSon, uniSon, maJorSecondUp, miNorThirdUp, perFectFourthUp, perFectFifthUp, miNorSixthUp, miNorSeventhUp
,octaVeUp]; // Natural Minor Scale Array
	~haRmiNorScale = [uniSon, uniSon, maJorSecondUp, miNorThirdUp, perFectFourthUp, perFectFifthUp, miNorSixthUp, maJorSeventhUp
,octaVeUp]; // Harmonic Minor Scale Array
	~meLmiNorScale = [uniSon, uniSon, maJorSecondUp, miNorThirdUp, perFectFourthUp, perFectFifthUp, maJorSixthUp, maJorSeventhUp, octaVeUp ,miNorSeventhUp, miNorSixthUp, perFectFifthUp, perFectFourthUp, miNorThirdUp, maJorSecondUp, uniSon];
	~maJ1Arpeggio = [uniSon, maJorThirdUp, perFectFifthUp]; // Major Arpeggio
	~miN1Arpeggio = [uniSon, miNorThirdUp, perFectFifthUp]; // Minor Arpeggio 1(Chord number 1)
	~doM5Arpeggio = [perFectFifthUp, maJorSeventhUp, uniSon];     // (Chord number 5)

	~miN1Arpeggio4 = ~miN1Arpeggio3.collect{|allnotes10| (allnotes10 * 2)};
	~miN1Arpeggio3 = ~miN1Arpeggio2.collect{|allnotes10| (allnotes10 * 2)};
	~miN1Arpeggio2 = ~miN1Arpeggio.collect{|allnotes10| (allnotes10 * 2)};
	~miN1Arpeggio0 = ~miN1Arpeggio.collect{|allnotes10| (allnotes10 / 2)}; //
	~miN1Arpeggio00 = ~miN1Arpeggio0.collect{|allnotes13| (allnotes13 / 2)};
	~miN1ArpeggioAll = [~miN1Arpeggio0[0], ~miN1Arpeggio0[1], ~miN1Arpeggio0[2], ~miN1Arpeggio[0], ~miN1Arpeggio[1], ~miN1Arpeggio[2], ~miN1Arpeggio2[0], ~miN1Arpeggio2[1], ~miN1Arpeggio2[2], ~miN1Arpeggio3[0], ~miN1Arpeggio3[1], ~miN1Arpeggio3[2], ~miN1Arpeggio4[0], ~miN1Arpeggio4[1], ~miN1Arpeggio4[2]].collect{|allnotes10| allnotes10};

	~doM5Arpeggio4 = ~doM5Arpeggio3.collect{|allnotes10| (allnotes10 * 2)};
	~doM5Arpeggio3 = ~doM5Arpeggio2.collect{|allnotes10| (allnotes10 * 2)};
	~doM5Arpeggio2 = ~doM5Arpeggio.collect{|allnotes10| (allnotes10 * 2)};
	~doM5Arpeggio0 = ~doM5Arpeggio.collect{|allnotes10| (allnotes10 / 2)}; //
	~doM5Arpeggio00 = ~doM5Arpeggio0.collect{|allnotes13| (allnotes13 / 2)};
	~doM5ArpeggioAll = [~doM5Arpeggio0[0], ~doM5Arpeggio0[1], ~doM5Arpeggio0[2], ~doM5Arpeggio[0], ~doM5Arpeggio[1], ~doM5Arpeggio[2], ~doM5Arpeggio2[0], ~doM5Arpeggio2[1], ~doM5Arpeggio2[2], ~doM5Arpeggio3[0], ~doM5Arpeggio3[1], ~doM5Arpeggio3[2], ~doM5Arpeggio4[0], ~doM5Arpeggio4[1], ~doM5Arpeggio4[2]].collect{|allnotes10| allnotes10};
	"Interval Frequencies and Call Numbers"
}
)
















