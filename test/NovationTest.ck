
NovationLaunchKey.with(0, 1) @=> NovationLaunchKey @ n;

fun void handle_note() {
    while (true) {
        n.note_key() => now;
        n.note_key().copy().debug();
    }
}

fun void other() {
    while (true) {
        n.pot(1).debug();
        n.master().debug();
        <<< "Pitch: ", n.pitch() >>>;
        1::second => now;
    }
}

spork ~ handle_note();
spork ~ other();

Machine.status();

1::hour => now;
