MidiDaemon.with(0) @=> MidiDaemon @ d;
MidiDaemon.with(1) @=> MidiDaemon @ i;

0 => int derp;

fun void handle_note() {
    while (true) {
        d.note() => now;
        d.note().copy().debug();
        i.send_note(1, 16, 40, derp++ % 127);
    }
}

fun void handle_control() {
    while (true) {
        d.control() => now;
        d.control().copy().debug();
        i.send_note(1, 16, 41, derp++ % 127);
    }
}

fun void handle_pitch_bend() {
    while (true) {
        d.pitch_bend() => now;
        d.pitch_bend().copy().debug();
        i.send_note(1, 16, 42, derp++ % 127);
    }
}

spork ~ handle_note();
spork ~ handle_control();
spork ~ handle_pitch_bend();

1::hour => now;
