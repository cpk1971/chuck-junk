public class MidiDaemon {
    int device;

    // state
    MidiIn min;
    MidiOut mout;
    MidiMsg msg;
    NoteEvent on_note;
    ControlEvent on_control;
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

    fun void run() {
        while (true) {
            min => now;
            while ( min.recv(msg) ) {
                if (msg.data1 >= 128 && msg.data1 <= 142 ) {
                    // note off
                    send_note(0, msg.data1 - 127);
                }
                else if (msg.data1 >= 144 && msg.data1 <= 159 ) {
                    // note on
                    send_note(1, msg.data1 - 143);
                } else if (msg.data1 >= 176 && msg.data1 <= 191 ) {
                    send_control();
                } else {
                    <<<"Unimplemented", msg.data1, msg.data2, msg.data3>>>;
                }
            }
        }
    }

    fun void send_note(int onoff, int channel) {
        onoff => on_note.on;
        channel => on_note.channel;
        msg.data2 => on_note.value; 
        msg.data3 => on_note.velocity;
        on_note.broadcast();
        me.yield();
    }

    fun void send_control() {
        msg.data1 - 175 => on_control.channel;
        msg.data2 => on_control.message;
        msg.data3 => on_control.value;
        on_control.broadcast();
        me.yield();
    }
}

