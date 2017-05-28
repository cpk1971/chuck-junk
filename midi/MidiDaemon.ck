public class MidiDaemon {
    int device;

    // state
    MidiIn min;
    MidiOut mout;
    MidiMsg msg;
    NoteEvent on_note;
    ControlEvent on_control;
    PitchBendEvent on_pitch_bend;
    Shred @ main_shred;

    fun static MidiDaemon @ with(int device) {
        new MidiDaemon @=> MidiDaemon @m;
        device => m.device;
        m.start();
        return m;
    }
    
    fun void start() {
        if (main_shred == null) {
            if (!min.open(device)) {
                <<< "couldn't open MIDI device for input", device >>>;
                return;
            }
            if (!mout.open(device)) {
                <<< "couldn't open MIDI device for output", device >>>;
                return;
            }
            <<< "MIDI device:", min.num(), " -> ", min.name() >>>;
            spork ~ run() @=> main_shred;
        }
    }

    fun void stop() {
        if (main_shred != null) {
            main_shred.exit();
            null @=> main_shred;
        }
    }

    fun NoteEvent @ note() {
        return on_note;
    }

    fun ControlEvent @ control() {
        return on_control;
    }

    fun PitchBendEvent @ pitch_bend() {
        return on_pitch_bend;
    }

    // private methods

    fun int msg_type() {
        return msg.data1 & 0xF0;
    }

    fun int msg_channel() {
        return (msg.data1 & 0x0F) + 1;
    }

    fun void run() {
        0x80 => int NOTE_OFF;
        0x90 => int NOTE_ON;
        0xB0 => int CONTROL_CHANGE;
        0xE0 => int PITCH_BEND;
        while (true) {
            min => now;
            while ( min.recv(msg) ) {
                msg_type() => int type;
                if (type == NOTE_OFF) {
                    broadcast_note(0);
                } else if (type == NOTE_ON) {
                    broadcast_note(1);
                } else if (type == CONTROL_CHANGE) {
                    broadcast_control();
                } else if (type == PITCH_BEND) {
                    broadcast_pitch_bend();
                } else {
                    <<<"Unimplemented", msg.data1, msg.data2, msg.data3>>>;
                }
                10::ms => now;
            }
        }
    }

    fun void broadcast_note(int onoff) {
        onoff => on_note.on;
        msg_channel() => on_note.channel;
        msg.data2 => on_note.value; 
        msg.data3 => on_note.velocity;
        on_note.signal();
    }

    fun void broadcast_control() {
        msg_channel() => on_control.channel;
        msg.data2 => on_control.message;
        msg.data3 => on_control.value;
        on_control.signal();
    }

    fun void broadcast_pitch_bend() {
        msg_channel() => on_pitch_bend.channel;
        msg.data2 => on_pitch_bend.lsb;
        msg.data3 => on_pitch_bend.msb;
        on_pitch_bend.signal();
    }

    fun void send_note(int onoff, int channel, int value, int velocity) {
        MidiMsg msg;
        (onoff ? 0x90 : 0x80) | ((channel-1) & 0x0F) => msg.data1;
        value => msg.data2;
        velocity => msg.data3;
        mout.send(msg);
    }

    fun void send_cc(int channel, int message, int value) {
        MidiMsg msg;
        0xB0 | ((channel-1) & 0x0F) => msg.data1;
        message => msg.data2;
        value => msg.data3;
        mout.send(msg);
    }
}

