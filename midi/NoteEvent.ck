public class NoteEvent extends Event {
    int on;
    int channel;
    int value;
    int velocity;

    fun void debug() {
        <<< "NoteEvent", on, channel, value, velocity >>>;
    }

    fun NoteEvent @ copy() {
        new NoteEvent @=> NoteEvent @ e;
        on => e.on;
        channel => e.channel;
        value => e.value;
        velocity => e.velocity;
        return e;
    }
}
