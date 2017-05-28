public class ControlEvent extends Event {
    int channel;
    int message;
    int value;

    fun void debug() {
        <<< "ControlEvent: ", channel, message, value >>>;
    }

    fun ControlEvent @ copy() {
        return copyTo(new ControlEvent);
    }

    fun ControlEvent @ copyTo(ControlEvent @ e) {
        channel => e.channel;
        message => e.message;
        value => e.value;
        return e;
    }
}
