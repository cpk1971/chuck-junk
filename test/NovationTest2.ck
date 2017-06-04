class Delegate extends VoiceDelegate {
    Clarinet c[10];
    Gain g => JCRev r => BPF f => dac;
    160.0 => f.freq;
    1.0 => f.Q;
    .1 => g.gain;
    .2 => r.mix;

    fun void voice_on(int voice, int note, int velocity) {
        <<< "On: ", voice, note, velocity >>>;
        c[voice] => g;
        Std.mtof(note) => c[voice].freq;
        .4 + velocity / 128.0 * .6 => c[voice].startBlowing;
    }

    fun void voice_off(int voice, int note) {
        <<< "Off: ", voice, note >>>;
        c[voice].stopBlowing(10.0);
        100::ms => now;
        c[voice] =< g;
    }
}

NovationLaunchKey.with(0, 1) @=> NovationLaunchKey @ n;
Delegate d;
Polyphony.with(n.note_key_channel(), n.note_key(), d, 10) @=> Polyphony p;

Machine.status();

while(true) {
    Std.mtof(n.pot(1).value) => d.f.freq;
    n.pot(2).zeroOne() * 10 => d.f.Q;
    1::ms => now;
}
