class Delegate extends VoiceDelegate {
    fun void voice_on(int voice, int note, int velocity) {
        <<< "On: ", voice, note, velocity >>>;
    }

    fun void voice_off(int voice, int note) {
        <<< "Off: ", voice, note >>>;
    }
}

NovationLaunchKey.with(0, 1) @=> NovationLaunchKey @ n;
Polyphony.with(n.note_key_channel(), n.note_key(), new Delegate, 10) @=> Polyphony p;

Machine.status();

1::hour => now;
