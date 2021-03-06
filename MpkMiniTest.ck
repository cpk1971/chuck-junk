//  run with chuck perform/MidiDelegate perform/MpkMini MpkMiniTest

class Delegate extends MidiDelegate {
    fun void noteOn(int voice, int note, int velocity) {
        <<< "noteOn", voice, note, velocity >>>;
    }

    fun void noteOff(int voice, int note) {
        <<< "NoteOff", voice, note >>>;
    }

    fun void control(int channel, int value) {
        <<< "Control", channel, value >>>;
    }
}

Delegate d;

MpkMini.with(0, d, 20) @=> MpkMini @ mpk;

2::second => now;

Machine.status();

1::hour => now;
