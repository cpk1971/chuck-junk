// from Kapur, Cook, et al
// p. 154

SawOsc folds => ResonZ formant1 => dac;
folds => ResonZ formant2 => dac;
folds => ResonZ formant3 => dac;

// modulate (vibrato)
SinOsc vibrato => folds;
6.0 => vibrato.freq;
1.5 => vibrato.gain;
2 => folds.sync;

// filter resonances
20 => formant1.Q => formant2.Q => formant3.Q;

// sing it
while(1) {
    Math.random2f(200,750) => formant1.freq;
    Math.random2f(900,2300) => formant2.freq;
    Math.random2f(2400,3600) => formant3.freq;
    if (Math.random2(0,3) == 0) {
        Math.random2f(60.0,200.0) => folds.freq;
    }
    Math.random2f(0.2,0.5)::second => now;
}
