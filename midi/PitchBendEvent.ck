public class PitchBendEvent extends Event {
    int channel;
    int lsb;
    int msb;

    fun void debug() {
        <<< "PitchBendEvent: ", channel, lsb, msb, value() >>>;
    }

    fun int value() {
        return (lsb << 7) | msb;
    }

    fun PitchBendEvent @ copy() {
        new PitchBendEvent @=> PitchBendEvent e;
        channel => e.channel;
        lsb => e.lsb;
        msb => e.msb;
        return e;
    }
}
