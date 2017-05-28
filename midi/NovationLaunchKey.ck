public class NovationLaunchKey {
    MidiDaemon @ basic;
    MidiDaemon @ in_control;
    Potentiometer pots[8];
    Potentiometer master;
    Potentiometer modulation;
    int pitch;
    int pitch_target;
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

    // private methods
    fun void setup() {
        100::samp => interpolation_period;
        64 => pitch_target => pitch;
        reset_pads;
        for (0 => int i; i < pots.cap(); i++) {
            i => pots[i].id;
            "pot " + Std.itoa(i) => pots[i].name;
        }
        pots.cap() => master.id;
        "master" => master.name;
        pots.cap() + 1 => modulation.id;
        "modulation" => modulation.name;
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
                on_note_key.broadcast();
                me.yield();
                return;
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
                    e.value => modulation.value;            
                } else if (e.message == 7) {
                    e.value => master.value;
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
            basic.pitch_bend().msb => pitch_target;
            me.yield();
       }
    }

    fun void interpolate() {
        // interpolate pitch
        // TODO maybe refactor?
        while (true) {
            if (pitch != pitch_target) {
                (pitch < pitch_target) ? 1 : -1 +=> pitch;
            }
            interpolation_period => now;
        }
    }
}
