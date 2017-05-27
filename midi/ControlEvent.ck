public class ControlEvent extends Event {
    int channel;
    int message;
    int value;

    fun void debug() {
        <<< "ControlEvent: ", channel, message, value >>>;
    }
}
