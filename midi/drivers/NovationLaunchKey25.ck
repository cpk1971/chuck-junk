public class NovationLaunchKey {
    MidiDaemon @ basic;
    MidiDaemon @ in_control;
    Potentiometer pots[8];
    Potentiometer _master;
    Potentiometer _modulation;
    int _pitch;
    int _pitch_target;
    dur interpolation_period;

    Shred @ shreds[4];
    NoteEvent on_note_key;

    fun static NovationLaunchKey @ with(MidiDaemon @ basic, MidiDaemon @ in_control) {
        new NovationLaunchKey @=> NovationLaunchKey @ n;
        basic @=> n.basic;
        in_control @=> n.in_control;
        n.setup();
        n.start();
        return n;
    }

    fun static NovationLaunchKey @ with(int basic, int in_control) {
        return with(MidiDaemon.with(basic), MidiDaemon.with(in_control));
    }

    fun Potentiometer @ pot(int which) {
        return pots[which - 1];
    }

    fun Potentiometer @ master() {
        return _master;
    }

    fun NoteEvent @ note_key() {
        return on_note_key;
    }

    // this is so we can abstractify this driver
    fun int note_key_channel() {
        return 1;
    }

    fun float pitch() {
        return ((_pitch - 64) $ float) / (_pitch < 64 ? 64 : 63);
    }

    // private methods
    fun void setup() {
        100::samp => interpolation_period;
        64 => _pitch_target => _pitch;
        reset_pads();
        for (0 => int i; i < pots.cap(); i++) {
            i => pots[i].id;
            "pot " + Std.itoa(i) => pots[i].name;
        }
        pots.cap() => _master.id;
        "master" => _master.name;
        pots.cap() + 1 => _modulation.id;
        "modulation" => _modulation.name;
    }

    fun void reset_pads() {
        in_control.send_cc(16, 0, 0);
    }


    fun void start() {
        if (shreds[0] == null) {
            spork ~ handle_note() @=> shreds[0];
            spork ~ handle_control() @=> shreds[1];
            spork ~ handle_pitch_bend() @=> shreds[2];
            spork ~ interpolate() @=> shreds[3];
        }
    }

    fun void stop() {
        for (0 => int i; i < shreds.cap(); i++) {
            shreds[i].exit();
            null @=> shreds[i];
        }
    }

    fun void handle_note() {
        while (true) {
            basic.note() => now;

            // an actual note!
            if (basic.note().channel == 1) {
                basic.note().copyTo(on_note_key);
                on_note_key.signal();
                me.yield();
                continue;
            }

            // TODO -- pads
        }
    }

    fun void handle_control() {
        ControlEvent e;
        while (true) {
            basic.control() => now;
            basic.control().copyTo(e); 
            if (e.channel == 1) {
                if (e.message == 1) {
                    e.value => _modulation.value;            
                } else if (e.message == 7) {
                    e.value => _master.value;
                } else if (e.message >= 21 && e.message <= 28) {
                    e.value => pots[e.message - 21].value;
                }
            }
        }
    }

    fun void handle_pitch_bend() {
        PitchBendEvent e;
        // use msb only because lsb is wonky
        while (true) {
            basic.pitch_bend() => now;
            basic.pitch_bend().msb => _pitch_target;
            me.yield();
       }
    }

    fun void interpolate() {
        // interpolate pitch
        // TODO maybe refactor?
        while (true) {
            if (_pitch != _pitch_target) {
                (_pitch < _pitch_target) ? 1 : -1 +=> _pitch;
            }
            interpolation_period => now;
        }
    }
}
