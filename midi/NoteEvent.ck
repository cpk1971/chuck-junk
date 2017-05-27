public class NoteEvent extends Event {
    int on;
    int channel;
    int value;
    int velocity;

    fun void debug() {
        <<< "NoteEvent", on, channel, value, velocity >>>;
    }
}
