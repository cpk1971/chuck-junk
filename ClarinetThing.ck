//  run with chuck perform/MidiDelegate perform/MpkMini MpkMiniTest

class Delegate extends MidiDelegate {
    Clarinet c[20];
    Gain g => JCRev r => dac;
    .1 => g.gain;
    .2 => r.mix;

    fun void noteOn(int voice, int note, int velocity) {
        <<< "noteOn", voice, note, velocity >>>;
        c[voice] => g;
        Std.mtof(note) => c[voice].freq;
        .4 + velocity / 128.0 * .6 => c[voice].startBlowing;
    }

    fun void noteOff(int voice, int note) {
        <<< "NoteOff", voice, note >>>;
        c[voice].stopBlowing(10.0);
        100::ms => now;
        c[voice] =< g;

    }

    fun void control(int channel, int value) {
        if (channel == 1) {
            value / 127.0 => float mix;
            <<< "reverb wet/dry =>", mix >>>;
            mix => r.mix;
        }
    }
}

Delegate d;

MpkMini.with(0, d, d.c.size()) @=> MpkMini @ mpk;

2::second => now;

Machine.status();

1::hour => now;
