public class Polyphony {
    int channel;
    NoteEvent @ on_note;
    VoiceDelegate @ delegate;
    int voices;

    // state
    NoteEvent on;
    Event @ us[128];
    Shred @ main_shred;

    fun static Polyphony @ with(int channel, NoteEvent @ on_note, VoiceDelegate @ delegate) {
        new Polyphony @=> Polyphony @ p;
        channel => p.channel;
        on_note @=> p.on_note;
        delegate @=> p.delegate;
        p.start();
        return p;
    }
    
    fun void start() {
        if (main_shred == null) {
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
            on.value => note;
            delegate.voice_on(voice, note, on.velocity);
            off @=> us[note];

            off => now;
            null @=> us[note];
            delegate.voice_off(voice, note);
        }
    }

    fun void run() {
        for ( 0 => int i; i < voices; i++ ) {
            spork ~ handle_voice(i);
        }

        while (true) {
            on_note => now;
            // not mine
            if (on_note.channel != channel) {
                continue;
            }
            on_note.copyTo(on);
            if (on.on && on.velocity > 0) {
                on.signal();
                me.yield();
            } else {
                if(us[on.value] != null) {
                    us[on.value].signal();
                }
            }
        }
    }
}

