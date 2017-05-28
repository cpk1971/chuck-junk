public class LatchEvent extends Event {
    int on;
    int velocity;

    fun void debug() {
        <<< "LatchEvent", on, velocity >>>;
    }

    fun LatchEvent @ copy() {
        new LatchEvent @=> LatchEvent @e;
        on => e.on;
        velocity => e.velocity;
        return e;
    }
}
