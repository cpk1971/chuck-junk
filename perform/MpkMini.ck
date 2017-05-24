class NoteEvent extends Event {
    int note;
    int velocity;
}

public class MpkMini {
    // config
    int device;
    MidiDelegate @ delegate;
    int voices;

    // state
    MidiIn min;
    MidiMsg msg;
    NoteEvent on;
    Event @ us[128];
    Shred @ main_shred;

    fun static MpkMini @ with(int device, MidiDelegate @ delegate, int voices) {
        new MpkMini @=> MpkMini @ m;
        device => m.device;
        delegate @=> m.delegate;
        voices => m.voices;
        m.start();
        return m;
    }
    
    fun void start() {
        if (main_shred == null) {
            if (!min.open(device)) {
                <<< "couldn't open MIDI device", device >>>;
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

    fun void handle_voice(int voice) {
        Event off;
        int note;

        // when the "on" event triggers, it is no longer listening on the "on" event
        // so the next "on" event will grab the next shred
        // not sure what happens if you run out of shreds
        while( true ) {
            on => now;
            on.note => note;
            delegate.noteOn(voice, note, on.velocity);
            off @=> us[note];

            off => now;
            null @=> us[note];
            delegate.noteOff(voice, note);
        }
    }

    fun void run() {
        for ( 0 => int i; i < voices; i++ ) {
            spork ~ handle_voice(i);
        }

        while (true) {
            min => now;
            while ( min.recv(msg) ) {
                if ( msg.data1 == 176 ) {
                    delegate.control(msg.data2, msg.data3);
                    continue;
                } else if (msg.data1 != 144) {
                    if (us[msg.data2] != null) {
                        us[msg.data2].signal();
                    }
                    continue;
                }
                if ( msg.data3 > 0 ) {
                    msg.data2 => on.note;
                    msg.data3 => on.velocity;
                    on.signal();
                    me.yield();
                } else {
                    if (us[msg.data2] != null) us[msg.data2].signal();
                }
            }
        }
    }
}

