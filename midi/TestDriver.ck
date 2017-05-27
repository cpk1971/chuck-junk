MidiDaemon.with(0) @=> MidiDaemon @ d;

fun void handle_note() {
    while (true) {
        d.on_note => now;
        d.on_note.debug();
    }
}

fun void handle_control() {
    while (true) {
        d.on_control => now;
        d.on_control.debug();
    }
}

spork ~ handle_note();
spork ~ handle_control();

1::hour => now;
