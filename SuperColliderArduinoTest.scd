// INITIALIZE EVERYTHING
s.waitForBoot({

~masterRoutine = Routine {
    
p = SerialPort(
   "/dev/cu.SLAB_USBtoUART",
   baudrate: 9600,
   crtscts: true
);

1.postln;        
0.5.wait;

~incrYR = 0;
~incrXR = 0;
~incrYL = 0;
~incrXL = 0;

r = Routine({
    var byte, str;
    99999.do{|i|
       if(p.read==10, {
            str = "";
			while({byte = p.read; byte != 13 }, {
                 str = str++byte.asAscii;
            });

			~valArray = str.split($ ).postln;

            if (~valArray.size == 8, {
                ~xValR = ~valArray[0].asInteger;
                ~yValR = ~valArray[1].asInteger;
                ~buttonValR = ~valArray[2].asInteger;
                ~switchValR = ~valArray[3].asInteger;
                ~xValL = ~valArray[4].asInteger;
                ~yValL = ~valArray[5].asInteger;
                ~buttonValL = ~valArray[6].asInteger;
                ~switchValL = ~valArray[7].asInteger});

            //[~xValL, ~yValL].postln;

			if(~xValR <= 1200, {~incrXR = -3});
			if((~xValR > 1200) && (~xValR <= 1800), {~incrXR = -1.5});
			if((~xValR > 1800) && (~xValR <= 1850), {~incrXR = 0});
			if((~xValR > 1850) && (~xValR <= 3800), {~incrXR = 1.5});
			if(~xValR > 3800, {~incrXR = 3});

			if(~yValR <= 700, {~incrYR = -3});
			if((~yValR > 700) && (~yValR <= 1900), {~incrYR = -1.5});
			if((~yValR > 1900) && (~yValR <= 1950), {~incrYR = 0});
			if((~yValR > 1950) && (~yValR <= 3000), {~incrYR = 1.5});
			if(~yValR > 3000, {~incrYR = 3});

            if(~xValL <= 800, {~incrXL = -3});
			if((~xValL > 800) && (~xValL <= 1775), {~incrXL = -1.5});
			if((~xValL > 1775) && (~xValL <= 1825), {~incrXL = 0});
			if((~xValL > 1825) && (~xValL <= 4000), {~incrXL = 1.5});
			if(~xValL > 4000, {~incrXL = 3});

			if(~yValL <= 700, {~incrYL = -3});
			if((~yValL > 700) && (~yValL <= 1500), {~incrYL = -1.5});
			if((~yValL > 1950) && (~yValL <= 2000), {~incrYL = 0});
			if((~yValL > 2000) && (~yValL <= 3300), {~incrYL = 1.5});
			if(~yValL > 3300, {~incrYL = 3});

       });
    };
}).play;
        
2.postln;        


~curValYL = ~yValL;
~curValXL = ~xValL;
~curValYR = ~yValR;
~curValXR = ~xValR;

//);

//r.stop;



//(
SynthDef (\morphPad, {|freq=1000, ampMaster=1900, amp1, amp2, amp3, amp4, dur, vibRate = 4, vibDepth = 0.1, blendX=1900, blendY=1900, pan, out, lpfCut=1900, hpfCut=1900, phaseRate=100, verb=1900|
	var sig, sig1, sig1a, sig1b, sig1c, sig2, sig2a, sig2b, sig3, sig3a, sig3b, sig3c, sig4a, sig4b, sig4, vib, filterLFO, phaser;
	vib = SinOsc.kr(vibRate).range(freq * (1 - vibDepth), freq * (1 + vibDepth));
	//env = Env.linen(0.1, dur, 2).kr(doneAction: 2);
	filterLFO = SinOsc.kr(0.5, 0, 1000);

    sig1a = Pan2.ar(Saw.ar(((freq).linexp(0, 4096, 1000, 100) - 2).lag(5) + SinOsc.kr(5, mul: 3), 0.8));
    sig1b = Pan2.ar(Saw.ar(((freq).linexp(0, 4096, 1000, 100) + 2).lag(5) + SinOsc.kr(5, mul: 3), 0.8));
    sig1c = Saw.ar(((freq).linexp(0, 4096, 1000, 100) / 2).lag(5) + SinOsc.kr(5, mul: 3), 0.8);
	sig1 = Mix([sig1a, sig1b, sig1c]);
	//sig1 = RLPF.ar(sig1, 6000 + filterLFO, 0.5);
    sig1 = sig1 * (blendX).linlin(0, 4096, 0, 1).lag(5);

	sig2a = PinkNoise.ar(0.7);
	sig2b = DelayL.ar(PinkNoise.ar(0.7), 0.3, 0.2);
	sig2 = Mix([sig2a, sig2b]) !2;
//	sig2 = RLPF.ar(sig2, 4000 + filterLFO, 1);
	//sig2 = RHPF.ar(sig2, 250, 1);
	sig2 = sig2 * (blendX).linlin(0, 4096, 1, 0).lag(5);

    sig3a = Pan2.ar(SinOsc.ar(((freq).linexp(0, 4096, 1000, 100) - 2).lag(5) + SinOsc.kr(1, mul: 10), mul: 0.8), -0.5) ;
	sig3b = Pan2.ar(SinOsc.ar(((freq).linexp(0, 4096, 1000, 100) + 2).lag(5) + SinOsc.kr(1, mul: 10), mul: 0.8), 0.5);
	sig3c = SinOsc.ar(((freq).linexp(0, 4096, 1000, 100) * 2).lag(5) + SinOsc.kr(1, mul: 10), mul: 0.8);
	sig3 = Mix([sig3a, sig3b, sig3c]);
	//sig3 = RLPF.ar(sig3, 6000 + filterLFO, 0.5, 0.5);
    //phaser = Mix(Array.fill(6, {AllpassL.ar(sig3, 1, SinOsc.ar(0.1, 0, 0.005, 0.0051), 0, 0.4)}));
    sig3 = AllpassL.ar(sig3, 4, SinOsc.ar((phaseRate).linexp(0, 4096, 0.5, 1000).lag(5), 0, 0.005, 0.01), 0, 0.7);
	sig3 = sig3 * (blendY).linlin(0, 4096, 0, 1).lag(5);

    sig4a = { Pulse.ar([(freq).linexp(0, 4096, 1000, 100).lag(5), (freq).linexp(0, 4096, 1000, 100).lag(5) *2.5], 0.5, 0.3) };
    sig4b = { Pulse.ar([(freq).linexp(0, 4096, 1000, 100).lag(5) *2, (freq).linexp(0, 4096, 1000, 100).lag(5) *4], 0.5, 0.3)};
    sig4 = Mix([sig4a, sig4b]);
    sig4 = sig4 * (blendY).linlin(0, 4096, 1, 0).lag(5);

    sig = RLPF.ar(Mix([sig1, sig2, sig3, sig4]), (lpfCut).linexp(0, 4096, 700, 18000).lag(5), 0.5);
    sig = RHPF.ar(sig, (hpfCut).linexp(0, 4096, 20, 500).lag(5), 0.5);
    sig = FreeVerb.ar(sig, (verb).linlin(0, 4096, 0, 1).lag(5), 0.8);


    Out.ar(out, sig * LinLin.kr(ampMaster, 0, 4096, 0, 1).lag(4));
}).add;

s.sync;
~noisey = Synth(\morphPad, [\freq, 1000, \amp1, 1, \dur, 1, \pan, 0, \out, 0, \ampMaster, 0]);
//)

//.stop;

//~test = Synth(\morphPad, [\freq, 600, \amp1, 1, \dur, 100, \pan, 0, \out, 0, \blendX, 2000, \blendY, 2000, \ampMaster, 4000]);



/*s.quit;
~rou.stop;
s.boot;*/







~winenv = Env([0, 0.8, 0.2,0.8, 0.2, 0.8, 0], 0.5 ! 6, [6, -4, 4, -4, 4, 6]);
y = Buffer.sendCollection(s, ~winenv.discretize, 1);

SynthDef(\grain_synths, {|gate=1, rate=1900, amp=1900, gSize=1900, carFreq=1900, modFreq=1900, chaos=1900, random=0, envbuf, subFreq=1900, lpfCut=1900, hpfCut=1900|
    var env, sig, sig1, sig2, sig3, freqdev, w, x, y, z, trig;
    env = EnvGen.kr(
        Env([0, 1, 0], [1, 1], \sin, 1),
        gate,
        doneAction: 2);

            sig1 = GrainIn.ar(2, Impulse.kr(rate.linexp(0, 4096, 5, 20).lag(5)), 0.1 * env,
                LFTri.ar(subFreq.linlin(0, 4096, 100, 20).lag(5) + Saw.ar(rate.linlin(0, 4096, 0.5, 3).lag(5), mul: 20), mul: 0.5), 0, envbuf);

            freqdev = LFNoise1.kr(50).range(0, random.linexp(0, 4096, 0.001, 1000).lag(5));
            sig2 = FMGrain.ar(Impulse.ar(rate.linexp(0, 4096, 3, 30).lag(5)), gSize.linlin(0, 4096, 0.05, 0.4).lag(5), carFreq.linexp(0, 4096, 2000, 80).lag(5) + freqdev, carFreq.linexp(0, 4096, 80, 2000).lag(5) / 2,
                LFNoise1.kr(chaos.linlin(0, 4096, 1, 5).lag(5)).range(1, 10),
            EnvGen.kr(
                Env([0, 1, 0], [1, 1], \sin, 1),
                gate,
                levelScale: 0.2,
                doneAction: 2)
        );

            trig = Impulse.kr((rate).linexp(0, 4096, 5, 30).lag(5));
    #w, x, y, z = SinGrainBBF.ar(trig, 0.05, carFreq.linexp(0, 4096, 2000, 80).lag(5), envbuf,
        WhiteNoise.kr.range(-0.25pi, 0.25pi), 0, 1,
            EnvGen.kr(
                Env([0, 1, 0], [1, 1], \sin, 1),
                gate,
                doneAction: 2)
            );
    sig3 = DecodeB2.ar(4, w, x, y);

            sig = RLPF.ar(Mix([sig1, sig2, sig3]), (lpfCut).linexp(0, 4096, 700, 20000).lag(5), 0.5);
            sig = RHPF.ar(sig, (hpfCut).linexp(0, 4096, 20, 500).lag(5), 0.5);

    sig = FreeVerb.ar(sig, 0.4, 0.7);

            Out.ar([0 , 1], sig * (amp).linlin(0, 4096, 0, 1).lag(5));
    
}).add;

s.sync;
        

~grainSynth = Synth(\grain_synths, [\rate, ~curValXR, \chaos, ~curValXR, \carFreq, ~curValYL, \modFreq, ~curValXL, \random, 0, \subFreq, ~curValYL, \amp, 0, \envbuf, y]);


//r.stop;
//s.boot;

/*~wef = Synth(\grain_synths, [\rate, 10, \chaos, 5, \carFreq, 30.0, \modFreq, 500, \random, 1000, \subFreq, 50]);

~wef.free;*/

3.wait;

~rou = Routine {
              
                ~curValXR = ~xValR;
                ~curValXL = ~xValL;
                ~curValYR = ~yValR;
                ~curValYL = ~yValL;
                loop {
                    ~curValYR = [[~curValYR + ~incrYR, 4096].minItem, 0].maxItem;
                    ~curValXR = [[~curValXR + ~incrXR, 4096].minItem, 0].maxItem;

                    ~curValYL = [[~curValYL + ~incrYL, 4096].minItem, 0].maxItem;
                    ~curValXL = [[~curValXL + ~incrXL, 4096].minItem, 0].maxItem;


                    if (~buttonValR == 0, {~noisey.set(\blendY, ~curValYR, \blendX, ~curValXR)},
                        {~noisey.set(\lpfCut, ~curValYR, \hpfCut, ~curValXR)});

                    if (~buttonValL == 0, {~noisey.set(\ampMaster, (~curValXL * ~switchValR * (~switchValL - 1).abs), \freq, ~curValYL)},
                        {~noisey.set(\phaseRate, ~curValXL, \verb, ~curValYL)});

                    0.005.wait;
        }
    }.play;

~grainR = Routine {
                ~curValXR = ~xValR;
                ~curValXL = ~xValL;
                ~curValYR = ~yValR;
                ~curValYL = ~yValL;
                loop {
                    ~curValYR = [[~curValYR + ~incrYR, 4096].minItem, 0].maxItem;
                    ~curValXR = [[~curValXR + ~incrXR, 4096].minItem, 0].maxItem;

                    ~curValYL = [[~curValYL + ~incrYL, 4096].minItem, 0].maxItem;
                    ~curValXL = [[~curValXL + ~incrXL, 4096].minItem, 0].maxItem;

                    if (~buttonValR == 0, {~grainSynth.set(\rate, ~curValYR, \gSize, ~curValXR, \chaos, ~curValXR)},
                        {~grainSynth.set(\lpfCut, ~curValYR, \hpfCut, ~curValXR)});

                    if (~buttonValL == 0, {~grainSynth.set(\amp, (~curValXL * ~switchValR * ~switchValL), \carFreq, ~curValYL)},
                        {~grainSynth.set(\random, ~curValXL, \subFreq, ~curValYL)});
                            
                    ~curValYR.postln;

                    0.005.wait;
                }
            }.play;
}.play;
    
});

//r.stop;



   

/*

s.boot;
r.stop;

~rou.stop
(
~startSynth = Routine {
    loop {
        ~switchValR.postln;
        if (~switchValR == 0, {

                ~rou = Routine {
                ~noisey = Synth(\morphPad, [\freq, 1000, \amp1, 1, \dur, 1, \pan, 0, \out, 0]);
                ~curValXR = ~xValR;
                ~curValXL = ~xValL;
                ~curValYR = ~yValR;
                ~curValYL = ~yValL;
                loop {
                    ~curValYR = [[~curValYR + ~incrYR, 4096].minItem, 0].maxItem;
                    ~curValXR = [[~curValXR + ~incrXR, 4096].minItem, 0].maxItem;

                    ~curValYL = [[~curValYL + ~incrYL, 4096].minItem, 0].maxItem;
                    ~curValXL = [[~curValXL + ~incrXL, 4096].minItem, 0].maxItem;


                    if (~buttonValR == 0, {~noisey.set(\blendY, ~curValYR, \blendX, ~curValXR)},
                        {~noisey.set(\lpfCut, ~curValYR, \hpfCut, ~curValXR)});

                    if (~buttonValL == 0, {~noisey.set(\ampMaster, ~curValXL, \freq, ~curValYL)},
                        {~noisey.set(\phaseRate, ~curValXL, \verb, ~curValYL)});

                    //if (~switchValR == 1, {~noisey.free});

                    0.005.wait;
                }
            }.play;
        }, {
                ~grainR = Routine {
                ~curValXR = ~xValR;
                ~curValXL = ~xValL;
                ~curValYR = ~yValR;
                ~curValYL = ~yValL;
                ~grainSynth = Synth(\grain_synths, [\rate, ~curValXR, \chaos, ~curValXR, \carFreq, ~curValYL, \modFreq, ~curValXL, \random, 0, \subFreq, ~curValYL]);
            
                loop {
                    ~curValYR = [[~curValYR + ~incrYR, 4096].minItem, 0].maxItem;
                    ~curValXR = [[~curValXR + ~incrXR, 4096].minItem, 0].maxItem;

                    ~curValYL = [[~curValYL + ~incrYL, 4096].minItem, 0].maxItem;
                    ~curValXL = [[~curValXL + ~incrXL, 4096].minItem, 0].maxItem;

                    if (~buttonValR == 0, {~grainSynth.set(\rate, ~curValYR, \gSize, ~curValXR, \chaos, ~curValXR)},
                        {~grainSynth.set(\lpfCut, ~curValYR, \hpfCut, ~curValXR)});

                    if (~buttonValL == 0, {~grainSynth.set(\amp, ~curValXL, \carFreq, ~curValYL)},
                        {~grainSynth.set(\random, ~curValXL, \subFreq, ~curValYL)});
                            
                    ~curValYR.postln;

                  //  if (~switchValR == 0, {~grainSynth.free});

                    0.005.wait;
                }
            }.play;
        });
    0.005.wait;

            }
}.play;

    )

)

~grainSynth.free;
s.kill;
~grainR.stop;

~startSynth.stop;*/

//Modify rate between 3 and 55
// Modify chaos between 1 and 5
// Modify carfreq between 80 and 2000
// Modify modFreq between 10 and 500
// Modify gsize between 0.05 and 1

// Modify Saw.ar rate between (0.5 and 3)
// Modify freq between 10 and 100
// Modify rate between 5 and 20

















/*
// Synth 3
(
SynthDef(\sin_grain, {arg gate = 1, amp = 1, envbuf, rate=20;
    var w, x, y, z, trig;
    trig = Impulse.kr(rate);
    #w, x, y, z = SinGrainBBF.ar(trig, 0.05, WhiteNoise.kr.range(440, 880), envbuf,
        WhiteNoise.kr.range(-0.25pi, 0.25pi), 0, 1,
            EnvGen.kr(
                Env([0, 1, 0], [1, 1], \sin, 1),
                gate,
                doneAction: 2)
            );
    Out.ar(0, DecodeB2.ar(4, w, x, y) * amp);
    }).add;

z = Env([0, 1, 0], [0.1, 0.9], [10, -5]).asSignal(1024);
s.sendMsg(\b_alloc, b = s.bufferAllocator.alloc(1), 1024, 1, [\b_setn, b, 0, 1024] ++ z);
)

s.boot;

s.sendMsg(\s_new, \sin_grain, a=s.nextNodeID, 0, 0, \amp, 1, \envbuf, b);
s.sendMsg(\n_set, a, \rate, 100, \amp, 0.5);

(
//s.sendMsg(\s_new, \sin_grain, a=s.nextNodeID, 0, 0, \amp, 1, \envbuf, b);
~rouGrain = Routine {
	//~grainTest = Synth(\grain_in, [\rate, 200, \gSize, 0.5, \freq, 600, \carFreq, 50, \modFreq, 200]);
   // ~sinGrain = Synth(\sin_grain_test, [\gate, 1, \amp, 1, \envbuf, b, \rate, 20]);
  //  s.sendMsg(\s_new, \sin_grain_test, a=s.nextNodeID, 0, 0, \amp, 1, \envbuf, b);
   // s.sendMsg(\s_new, \sin_grain, a=s.nextNodeID, 0, 0, \amp, 1, \envbuf, b);
	loop {
		//~curValY = [[~curValY + ~incrY, 4096].minItem, 0].maxItem;
		//~curValX = [[~curValX + ~incrX, 4096].minItem, 0].maxItem;
	//	~grainTest.set(\rate, ~curValX, \freq, ~curValY, \envbuf, z);
     //   ~sinGrain.set(\rate, 20);
        s.sendMsg(\n_set, a, \rate, 10, \amp, 0.5);
		0.005.wait;
	}
}.play;
)

s.sendMsg(\n_set, a, \rate, 10, \amp, 0.5);

s.freeAll;


(
a=s.nextNodeID;
s.sendMsg(\s_new, \sin_grain, a, 0, 0, \amp, 0.2, \envbuf, b);
)
s.sendMsg(\n_set, a, \gate, 0);
s.sendMsg(\n_set, a, \rate, 10);
s.sendMsg(\b_free, b);

x = Synth(\grain_in, [\envbuf, z, \rate, 3476, \gSize, 0.5, \carFreq, 50, \modFreq, 200, \out, 0, \amp, 1, \freq, 600]);

s.boot;
(
a=s.nextNodeID;
s.sendMsg(\s_new, \sin_grain, a=s.nextNodeID, 0, 0, \amp, 0.2, \envbuf, b);

~rouGrain = Routine {
	//~grainTest = Synth(\grain_in, [\rate, 200, \gSize, 0.5, \freq, 600, \carFreq, 50, \modFreq, 200]);
   // ~sinGrain = Synth(\sin_grain_test, [\gate, 1, \amp, 1, \envbuf, b, \rate, 20]);
  //  s.sendMsg(\s_new, \sin_grain_test, a=s.nextNodeID, 0, 0, \amp, 1, \envbuf, b);
	loop {
		//~curValY = [[~curValY + ~incrY, 4096].minItem, 0].maxItem;
		//~curValX = [[~curValX + ~incrX, 4096].minItem, 0].maxItem;
	//	~grainTest.set(\rate, ~curValX, \freq, ~curValY, \envbuf, z);
     //   ~sinGrain.set(\rate, 20);
        s.sendMsg(\n_set, ~next, \amp, 0.1);
		0.005.wait;
	}
}.play;
)

s.sendMsg(\n_set, a, \gate, 0);


~grainTest = Synth(\grain_in, [\rate, 1, \gSize, 0.1, \freq, 600]);

















~incrY.class;

([1, 2]).max;

s.quit;

SynthDef(\apad_mh, {
	arg
	//Standard Values:
	out = 0, pan = 0, freq = 880, amp = 0.5, att = 0.4, dec = 0.5, sus = 0.8, rel = 1.0, gate = 1,
	//Other Controls:
	vibratoRate = 4, vibratoDepth = 0.015, tremoloRate = 5,
	//These controls go from 0 to 1:
	tremoloDepth = 0.5, reverbMix = 0.5, roomSize = 1, damp = 0.5;

	var env, snd, vibrato, tremolo, mod2, mod3;

	env = Env.adsr(att, dec, sus, rel).kr(gate: gate);
	vibrato = SinOsc.kr(vibratoRate).range(freq * (1 - vibratoDepth), freq * (1 + vibratoDepth));
	tremolo = LFNoise2.kr(1).range(0.2, 1) * SinOsc.kr(tremoloRate).range((1 - tremoloDepth), 1);

	snd = SinOsc.ar(freq: [freq, vibrato], mul:(env * tremolo * amp)).distort;
	snd = Mix.ar([snd]);
	snd = FreeVerb.ar(snd, reverbMix, roomSize, damp);

	DetectSilence.ar(snd, 0.0001, 0.2, doneAction: 2);
	Out.ar(out, Pan2.ar(snd, pan));
},
metadata:(
	credit: "Mike Hairston",
	tags: [\pad, \vibrato, \sustained]
	)
).add;

~test1 = Synth(\apad_mh, [\freq, 440]);

~test = Synth(\morphPad, [\freq, 440, \amp1, 1, \dur, 3, \pan, 0, \out, 0]);


~pad2Test = Synth(\pad, [\freq, 500, \amp, 1, \dur, 10, \pan, -1, \out, 0]);
s.numSynths;

(
a = Routine{
	while ({true}, {~pad2Test.set(\freq, ~yVal)});
}.play;
)

(
~rou = Routine {
	~pad2Test = Synth(\pad, [\freq, 500, \amp, 1, \dur, 20, \pan, -1, \out, 0]);
	loop {
		~pad2Test.set(\freq, ~yVal/4);
		1.wait;
	}
}.play;
)

~rou.stop;






(
~pad2Test = Synth(\pad, [\freq, ~yVal/4, \amp, 1, \dur, 20, \pan, -1, \out, 0]);
1000.do{~pad2Test.set(\freq, ~yVal/4); 1.postln};
)



~pad2Test.stop;

(
var winenv, winenv2;
// a custom envelope
winenv = Env([0, 0.8, 0.2,0.8, 0.2, 0.8, 0], 0.5 ! 6, [6, -4, 4, -4, 4, 6]);
y = Buffer.sendCollection(s, winenv.discretize, 1);

winenv2 = Env([0, 1, 0.8, 0.2, 0.5, 0], [0.5, 0.5, 0.5, 0.5, 0.5], [8, -8, -4, 1, 16]);
z = Buffer.sendCollection(s, winenv2.discretize, 1);

SynthDef(\grain_in, {arg gate = 1, amp = 1, rate = 10, gSize = 0.05, freq=400, out=0, envbuf, sizeAtt=1, sizeRel=30, carFreq=440, modFreq=200, freqdev=400;
    var pan, env, sig1, sig2, sig3, sizeEnv, trig, w, x, y, z;

    pan = 0;
    env = EnvGen.kr(
        Env([0, 1, 0], [1, 1], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: 2);
    sig1 = GrainIn.ar(2, Impulse.kr(LinLin.kr(rate, 0, 4096, 1, 20)), gSize * env,
			SinOsc.ar(LinExp.kr(freq, 0.1, 4096, 100, 1000) + SinOsc.ar(1, mul: 10)) * 0.5, pan, envbuf);

    sig2 = FMGrain.ar(Impulse.ar(20), 0.2, 440, 200,
            LFNoise1.kr(1).range(1, 10),
            EnvGen.kr(
                Env([0, 1, 0], [1, 1], \sin, 1),
                gate,
                levelScale: 0.1,
                doneAction: 2)
        );

    sizeEnv = Env([0.01, 1, 0.01], [sizeAtt, sizeRel], [8, -8]).kr(doneAction: 2);
	sig3 = GrainFM.ar(2, Impulse.kr(rate), gSize * sizeEnv, carFreq + freqdev, modFreq, LFNoise1.kr.range(1, 10),
		pan, envbuf);
	sig3 = BBandPass.ar(sig3, 2000 + SinOsc.ar(0.25, mul:1000), 2, 1);

    Out.ar(out,
        Mix([sig2]) * env * amp)
    }).add;

)


// Synth 1
(
var winenv;
winenv = Env([0, 0.8, 0.2,0.8, 0.2, 0.8, 0], 0.5 ! 6, [6, -4, 4, -4, 4, 6]);
y = Buffer.sendCollection(s, winenv.discretize, 1);

SynthDef(\sub_grains, {|rate=50, gSize=0.1, freq=60, amp=1, envbuf, gate=1|
    var env, sig;
    env = EnvGen.kr(
        Env([0, 1, 0], [1, 1], \sin, 1),
        gate,
        doneAction: 2);

    sig = GrainIn.ar(2, Impulse.kr(rate), gSize * env,
			LFTri.ar(freq + Saw.ar(3, mul: 10)), 0, envbuf);
    Out.ar(0, sig * amp)}).add;
)

// Modify Saw.ar rate between (0.5 and 3)
// Modify freq between 10 and 100
// Modify rate between 5 and 20
~fwef = Synth(\sub_grains, [\envbuf, y]);


// Synth 2
(

SynthDef(\my_FM, {|rate=20, amp=1, gate=1, gSize=0.1, carFreq=440, modFreq=200, chaos=1, random=0|
    var sig2, freqdev;
    freqdev = LFNoise1.kr(50).range(0, random);
    sig2 = FMGrain.ar(Impulse.ar(rate), gSize, carFreq + freqdev, modFreq,
            LFNoise1.kr(chaos).range(1, 10),
            EnvGen.kr(
                Env([0, 1, 0], [1, 1], \sin, 1),
                gate,
                levelScale: 0.2,
                doneAction: 2)
        );

    Out.ar([0 ,1], sig2 * amp)}).add;
)

//Modify rate between 3 and 55
// Modify chaos between 1 and 5
// Modify carfreq between 80 and 2000
// Modify modFreq between 10 and 500
// Modify gsize between 0.05 and 1

~wef = Synth(\my_FM, [\rate, 10, \chaos, 5, \carFreq, 300, \modFreq, 500, \random, 1000]);*/







